# -*- encoding : utf-8 -*-
# Methods for querying and parsing the Primo PNX service
require 'rexml/document'
require 'net/http'
module PnxHelper

  def get_config
    @config = YAML.load_file("#{Rails.root}/config/pnx.yml")[Rails.env]
  end

  # search the pnx for e-books up to max_index
  def search_pnx
    responses = []
    # from 1 until the max index specified, search pnx, retrieving
    # the num results specified each time
    (1..@config['max_index']).each do |index|
      response = get_search_response(index, @config['bulk_size'])
      raise "Primo X-Services returned response #{response.code}" unless response.code == '200'
      responses.push(response)
    end
    responses
  end

  # given an array of responses
  # return an array of formatted queue messages
  def convert_to_messages(responses)
    message_array = []
    responses.each do |r|
      response_hashes = parse_response(REXML::Document.new(r.body))
      message_array.concat(response_hashes.map {|h| create_ingest_message(h)})
    end
    message_array
  end

  # sub the values specified into search url and get response
  def get_search_response(index, bulk_size)
    url = @config['url'] % {index: index, bulk_size: bulk_size}
    Net::HTTP.get_response(URI.parse(url))
  end

  # Given a complete response,
  # create an array of record hashes
  def parse_response(response_xml)
    record_array = []
    response_xml.elements.each('sear:SEGMENTS/sear:JAGROOT/sear:RESULT/sear:DOCSET/sear:DOC/PrimoNMBib/record/') do |elem|
      record_array.push(create_hash(elem))
    end
    record_array
  end

  # Given a single record xml
  # Create a record hash
  def create_hash(record_xml)
    extracted_elements = Hash.new
    record_xml.elements.each('control/sourcerecordid') do |control|
      extracted_elements['sourcerecordid'] = control.text

    end


    record_xml.elements.each('display') do |displaynode|
      displaynode.each_element_with_text do |displayelement|

        key = displayelement.name
        if extracted_elements.has_key? key
          if extracted_elements[key].is_a?(Array)
            value = extracted_elements[key]
          else
            value = [extracted_elements[key]]
          end
          value << displayelement.text
        else
          value = displayelement.text
        end
        extracted_elements[key] = value
      end
    end

    record_xml.elements.each('links/linktorsrc') do |links|
      key = "linktosrc"
      if extracted_elements.has_key? key
        if extracted_elements[key].is_a?(Array)
          value = extracted_elements[key]
        else
          value = [extracted_elements[key]]
        end
        value << parse_link_text(links.text)
      else
        value = parse_link_text(links.text)
      end
      extracted_elements[key] = value

    end

    extracted_elements
  end

  def create_ingest_message(record_hash)
    message_hash = Hash.new
    #cut out the barcode from the file link and remove pdf name
    message_hash[:id] = record_hash['linktosrc'].split('/').last.split('.')[0]
    message_hash[:fileUri] = record_hash['linktosrc']
    message_hash[:workflowId] = 'DOD'
    message_hash.to_json
  end

  private
  # The PNX link text includes MARC subfields
  # get rid of these and return just the link
  def parse_link_text(link_str)
    subfields = link_str.split(/\$\$[A-Z]/) # split on subfield divider
    subfields.reject! {|e| e.empty?} # dump empties
    subfields[0] # return the link
  end
end