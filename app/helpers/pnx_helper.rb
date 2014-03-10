# -*- encoding : utf-8 -*-
# Methods for querying and parsing the Primo PNX service
require "rexml/document"
module PnxHelper

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

  # The PNX link text includes MARC subfields
  # get rid of these and return just the link
  def parse_link_text(link_str)
    subfields = link_str.split(/\$\$[A-Z]/) # split on subfield divider
    subfields.reject! {|e| e.empty?} # dump empties
    subfields[0] # return the link
  end
end