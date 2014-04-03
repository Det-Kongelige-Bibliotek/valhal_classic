# -*- encoding : utf-8 -*-
#This module provides functionality for the handling of messages from the Digitisation On-Demand (DOD) workflow for
#digitised books at Det Kongelige Bibliotek. It includes logic for retrieving book meta-data from Aleph, converting it
#into MODS and saving the resulting MODS in a new Work in Valhal.
module DigitisationHelper

  SERVICES_CONFIG = YAML.load_file("#{Rails.root}/config/services.yml")[Rails.env]
  include ManifestationsHelper
  include PersonFinderService

  #Subscribe to the DOD Digitisation Workflow queue
  #@param channel The channel to the message broker.
  def subscribe_to_dod_digitisation(channel)
    if MQ_CONFIG["digitisation"]["source"].blank?
      logger.warn "#{Time.now.to_s} WARN: No digitisation source queue defined -> Not listening"
      return
    end

    logger.debug "DigitisationHelper.subscribe_to_dod_digitisation: num_of_threads = #{Thread.current.group.list.size}"
    if Thread.current.group.list.size > 1
      Thread.current.group.list.each do |thread|
        logger.debug thread.inspect
      end
    end

    source = MQ_CONFIG["digitisation"]["source"]
    q = channel.queue(source, :durable => true)
    logger.debug "Before Q subscribe DigitisationHelper.subscribe_to_dod_digitisation: num_of_threads = #{Thread.current.group.list.size}"
    #logger.info "Listening to DOD digitisation workflow queue: #{source}"

    q.subscribe do |delivery_info, metadata, payload|
      logger.debug "After Q subscribe DigitisationHelper.subscribe_to_dod_digitisation: num_of_threads = #{Thread.current.group.list.size}"
      begin
        logger.debug "#{Time.now.to_s} DEBUG: Received the following DOD eBook message: #{payload}"
        handle_digitisation_dod_ebook(JSON.parse(payload))
        logger.debug "Finished handling dod EBook"
      rescue => e
        logger.error "#{Time.now.to_s} ERROR: Tried to handle DOD eBook message: #{payload}\nCaught error: #{e}"
        logger.error e.backtrace.join("\n")
      end
    end
  end

  #Manages the process of creating a DOD work in Valhal by getting the required meta-data from Aleph
  #using the details contained in the message.  After getting the Aleph XML meta-data it transforms this to MODS
  #and creates the Work for persistence to Fedora and indexing into Solr.
  #@param message JSON format message about a DOD received from the DOD digitisation workflow
  # @return the created work for the dod-book.
  def create_dod_work(message)
    logger.debug "#{Time.now.to_s} DEBUG: Going to generate MODS for eBook..."
    service = AlephService.new
    #Getting the DanMARC record from Aleph for a digitised book is a 2-step process.  2 HTTP POSTs have to be made, the
    #first uses the ID of the book which is assumed to be a barcode to get a set_number back from Aleph.  This set_number
    #becomes the parameter to the second Aleph POST that returns the actual meta-data for the book in DanMARC format
    aleph_set_number = service.find_set("sys=#{message['id']}")[:set_num]
    aleph_marc_xml = service.get_record(aleph_set_number, "1")

    pdf_uri = message['fileUri']
    mods = transform_aleph_marc_xml_to_mods(aleph_marc_xml, pdf_uri, message['id'])

    logger.debug "#{Time.now.to_s} DEBUG: pdf_uri = #{pdf_uri}"
    work = update_or_create_work(message['id'], mods.to_s, pdf_uri)

    person = find_or_create_person(mods.to_s)
    unless person.nil?
      work.set_authors([person.pid], work)
    end
    work
  end

  #Function for transforming Aleph DanMARC XML into MODS.  The transformation process is a 2-step process.  First an XSLT
  #script is called that transforms the DanMARC XML into normal MARC 21 XML.  Secondly another XSLT is called to
  #transform the MARC 21 into MODS 3.5 XML using the marcToMODS XSLT script provided by the Library of Congress.
  #@param aleph_marc_xml - the aleph DanMARC XML in String format
  #@param pdf_uri - the URI to the location of the PDF file for this eBook in String format
  #@return Nokogiri::Document containing MODS XML
  def transform_aleph_marc_xml_to_mods(aleph_marc_xml, pdf_uri, id)
    logger.debug "#{Time.now.to_s} DEBUG: Running XSLT transformation of Aleph MARC XML to MODS..."
    tmp_doc = ConversionService.transform_aleph_to_slim_marc(aleph_marc_xml, pdf_uri)
    mods = ConversionService.transform_marc_to_mods(tmp_doc)

    recInfo = Nokogiri::XML::Node.new('recordInfo', mods)
    identifier = Nokogiri::XML::Node.new('recordIdentifier', mods)
    identifier.content = id
    identifier.set_attribute('source', 'kb-aleph')
    recInfo.children = identifier
    mods.css('mods location').last.add_next_sibling(recInfo)

    empty_uri_identifier_element = Nokogiri::XML::Node.new('identifier', mods)
    empty_uri_identifier_element.content = ''
    empty_uri_identifier_element.set_attribute('type', 'uri')
    mods.css('mods location').last.add_next_sibling(empty_uri_identifier_element)
    mods
  end

  #Function for creating a new Work in Valhal and adding a MODS datastream with MODS XML produced from transformation
  #of Aleph XML.
  #@param mods MODS XML in String format
  #@param pdflink URI to PDF file in String format
  #@return Work object or nil
  def update_or_create_work(id, mods, pdflink)
    logger.debug "update or create work #{id}"
    work = Work.find(sysNum_ssi: id).first
    work = Work.new if work.nil?
    logger.debug "Work is #{work.inspect}"
    work.datastreams['descMetadata'].content = mods
    work.work_type='DOD bog'
    work.shelfLocator = Nokogiri::XML.parse(mods).css('mods location physicalLocation').text
    if (!work.save)
      logger.error "#{Time.now.to_s} ERROR: Failed to save work #{work.errors.messages.flatten.join(' ')}"
      return nil
    end

    # create Basicfile with pdflink as content data stream
    logger.debug "creating basic file from #{pdflink}"
    file = BasicFile.new
    if (!file.add_file_from_server(pdflink))
      logger.error "#{Time.now.to_s} ERROR: Unable to add pdf_file from #{pdflink}"
      work.delete
      return nil
    end

    if (!file.save)
      logger.error "#{Time.now.to_s} ERROR: Unable to save basicfile #{file.errors.messages.flatten.join(' ')}"
      work.delete
      return nil
    end

    logger.debug "creating single file representation "
    rep = SingleFileRepresentation.new
    rep.files << file

    if (!rep.save)
      logger.error "#{Time.now.to_s} ERROR: Unable to save file representation #{rep.errors.messages.flatten.join(' ')}"
      work.delete
      file.delete #delete the BasicFile object again
      return nil
    end

    rep.ie = work
    work.representations << rep


    logger.debug "saving work"
    if (work.save)
      return work
    else
      rep.delete
      file.delete
      logger.error "#{Time.now.to_s} ERROR: Could not save work second time, #{work.errors.messages.flatten.join(' ')}. Returning nil"
      return nil
    end
  end
end
