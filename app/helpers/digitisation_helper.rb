# -*- encoding : utf-8 -*-
module DigitisationHelper

  SERVICES_CONFIG = YAML.load_file("#{Rails.root}/config/services.yml")[Rails.env]
  include ManifestationsHelper
  include PersonFinderService

  #Subscribe to the DOD Digitisation Workflow queue
  #@param channel The channel to the message broker.
  def subscribe_to_dod_digitisation(channel)
    if MQ_CONFIG["digitisation"]["source"].blank?
      logger.warn 'No preservation response queue defined -> Not listening'
      return
    end

    source = MQ_CONFIG["digitisation"]["source"]
    q = channel.queue(source, :durable => true)
    logger.info "Listening to DOD digitisation workflow queue: #{source}"

    q.subscribe do |delivery_info, metadata, payload|
      begin
        logger.debug "Received the following DOD eBook message: #{payload}"
        handle_digitisation_dod_ebook(JSON.parse(payload))
      rescue => e
        logger.error "Tried to handle DOD eBook message: #{payload}\nCaught error: #{e}"
      end
    end
  end

  #Manages the process of creating a DOD work in Valhal by getting the required meta-data from Aleph
  #using the details contained in the message.  After getting the Aleph XML meta-data it transforms this to MODS
  #and creates the Work for persistence to Fedora and indexing into Solr
  #@message JSON format message about a DOD received from the DOD digitisation workflow
  def create_dod_work(message)
    logger.debug 'Going to generate MODS for eBook...'
    aleph_set_number = get_aleph_set_number(message['id'])
    aleph_marc_xml = get_aleph_marc_xml(aleph_set_number)

    pdf_uri = message['fileUri']
    mods = transform_aleph_marc_xml_to_mods(aleph_marc_xml, pdf_uri)

    puts "mods = #{mods}"

    puts "pdf_uri = #{pdf_uri}"
    work = create_work_object(mods.to_s, pdf_uri)

    person = find_or_create_person(mods.to_s)
    unless person.nil?
      work.set_authors([person.pid], work)
    end
  end

  #Query Aleph X service to get the set_number for an eBook using the
  #eBooks barcode number.
  #@barcode 12 digit number
  def get_aleph_set_number(barcode)
    logger.debug "Looking up aleph set number using barcode: #{barcode}"
    #make http request for set number
    aleph_base_uri = SERVICES_CONFIG['aleph_base_url']
    http_service = HttpService.new
    aleph_set_number_xml = http_service.do_post(aleph_base_uri, params = {
                                                    "op" => "find",
                                                    "base" => "kgl01",
                                                    "library" => "kgl01",
                                                    "request" => "bar=#{barcode}"})
    logger.debug aleph_set_number_xml

    #get the set number out of XML
    aleph_set_number = Nokogiri::XML.parse(aleph_set_number_xml).xpath('/find/set_number/text()').to_s

    logger.debug "aleph_set_number = #{aleph_set_number}"

    aleph_set_number
  end

  def get_aleph_marc_xml(aleph_set_number)
    logger.debug "Looking up aleph marc xml using set_number: #{aleph_set_number}"

    aleph_base_uri = SERVICES_CONFIG['aleph_base_url']
    http_service = HttpService.new
    aleph_marc_xml = http_service.do_post(aleph_base_uri, params = {"op" => "present",
                                                                    "set_no" => "#{aleph_set_number}",
                                                                    "set_entry" => "000000001",
                                                                    "format" => "marc"})
    logger.debug "#{aleph_marc_xml}"
    aleph_marc_xml
  end

  def transform_aleph_marc_xml_to_mods(aleph_marc_xml, pdf_uri)
    logger.debug 'Running XSLT transformation of Aleph MARC XML to MODS...'
    doc = Nokogiri::XML.parse(aleph_marc_xml)
    xslt1 = Nokogiri::XSLT(File.read("#{Rails.root}/xslt/oaimarc2slimmarc.xsl"))
    tmp_doc = xslt1.transform(doc, Nokogiri::XSLT.quote_params(['pdfUri', "#{pdf_uri}"]))
    xslt2 = Nokogiri::XSLT(File.read("#{Rails.root}/xslt/marcToMODS.xsl"))
    mods = xslt2.transform(tmp_doc)
    return mods
  end


  def create_work_object(mods,pdflink)
    work = Work.new
    work.datastreams['descMetadata'].content = mods
    puts "#########"
    puts work.datastreams['descMetadata'].content.inspect
    puts "#########"
    work.work_type='DOD bog'
    if (!work.save)
      puts "Failed to save work"
      return nil
    end

    # create Basicfile with pdflink as content data stream
    file = BasicFile.new
    if (!file.add_file_from_url(pdflink,nil))
      logger.error "Unable to add pdffile from #{pdflink}"
      puts "Unable to add pdffile from #{pdflink}"
      work.delete
      return nil
    end

    if (!file.save)
      logger.error "Unable to save basicfile"
      puts "Failed to save basicfile"
      work.delete
      return nil
    end

    rep = SingleFileRepresentation.new
    rep.files << file

    if (!rep.save)
      logger.error "Unable to save file representation"
      puts "Unable to save file representation"
      work.delete
      file.delete #delete the BasicFile object again
      return nil
    end

    rep.ie = work
    work.representations << rep

    if (work.save)
      return work
    else
      rep.delete
      file.delete
      return nil
    end
  end
end