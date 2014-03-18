# -*- encoding : utf-8 -*-
#This module provides functionality for the handling of messages from the Digitisation On-Demand (DOD) workflow for
#digitised books at Det Kongelige Bibliotek. It includes logic for retrieving book meta-data from Aleph, converting it
#into MODS and saving the resulting MODS in a new Work in Valhal.
module DigitisationHelper

  SERVICES_CONFIG = YAML.load_file("#{Rails.root}/config/services.yml")[Rails.env]
  include ManifestationsHelper
  include PersonFinderService
  include DisseminationHelper

  #Subscribe to the DOD Digitisation Workflow queue
  #@param channel The channel to the message broker.
  def subscribe_to_dod_digitisation(channel)
    if MQ_CONFIG["digitisation"]["source"].blank?
      logger.warn 'No digitisation source queue defined -> Not listening'
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
  #and creates the Work for persistence to Fedora and indexing into Solr.
  #@param message JSON format message about a DOD received from the DOD digitisation workflow
  def create_dod_work(message)
    logger.debug 'Going to generate MODS for eBook...'
    #Getting the DanMARC record from Aleph for a digitised book is a 2-step process.  2 HTTP POSTs have to be made, the
    #first uses the ID of the book which is assumed to be a barcode to get a set_number back from Aleph.  This set_number
    #becomes the parameter to the second Aleph POST that returns the actual meta-data for the book in DanMARC format
    aleph_set_number = get_aleph_set_number(message['id'])
    aleph_marc_xml = get_aleph_marc_xml(aleph_set_number)

    pdf_uri = message['fileUri']
    mods = transform_aleph_marc_xml_to_mods(aleph_marc_xml, pdf_uri)

    logger.debug "mods = #{mods}"

    logger.debug "pdf_uri = #{pdf_uri}"
    work = create_work_object(mods.to_s, pdf_uri)

    person = find_or_create_person(mods.to_s)
    unless person.nil?
      work.set_authors([person.pid], work)
    end

    disseminate(work, message, DisseminationHelper::DISSEMINATION_TYPE_BIFROST_BOOKS)
  end

  #Query Aleph X service to get the set_number for an eBook using the eBooks barcode number. This is the first POST in
  #the 2 POST process of getting Aleph DanMARC metadata for an eBook.
  #@param barcode 12 digit number in String format
  #@return aleph_set_number
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

  #Query Aleph X Service for the Aleph DanMARC record for the corresponding set number.  This is the second POST in the
  #2 POST process of getting Aleph DanMARC metadata for a book.
  #@param aleph_set_number the set_number returned by Aleph for the book barcode which is then used to get the DanMARC
  #record for the eBook.
  #@return
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

  #Function for transforming Aleph DanMARC XML into MODS.  The transformation process is a 2-step process.  First an XSLT
  #script is called that transforms the DanMARC XML into normal MARC 21 XML.  Secondly another XSLT is called to
  #transform the MARC 21 into MODS 3.5 XML using the marcToMODS XSLT script provided by the Library of Congress.
  #@param aleph_marc_xml - the aleph DanMARC XML in String format
  #@param pdf_uri - the URI to the location of the PDF file for this eBook in String format
  #@return Nokogiri::Document containing MODS XML
  def transform_aleph_marc_xml_to_mods(aleph_marc_xml, pdf_uri)
    logger.debug 'Running XSLT transformation of Aleph MARC XML to MODS...'
    doc = Nokogiri::XML.parse(aleph_marc_xml)
    xslt1 = Nokogiri::XSLT(File.read("#{Rails.root}/xslt/oaimarc2slimmarc.xsl"))
    tmp_doc = xslt1.transform(doc, Nokogiri::XSLT.quote_params(['pdfUri', "#{pdf_uri}"]))
    xslt2 = Nokogiri::XSLT(File.read("#{Rails.root}/xslt/marcToMODS.xsl"))
    xslt2.transform(tmp_doc)
  end

  #Function for creating a new Work in Valhal and adding a MODS datastream with MODS XML produced from transformation
  #of Aleph XML.
  #@param mods MODS XML in String format
  #@param pdflink URI to PDF file in String format
  #@return Work object or nil
  def create_work_object(mods,pdflink)
    work = Work.new
    work.datastreams['descMetadata'].content = mods
    work.work_type='DOD bog'
    if (!work.save)
      logger.error "Failed to save work"
      return nil
    end

    # create Basicfile with pdflink as content data stream
    file = BasicFile.new
    if (!file.add_file_from_url(pdflink,nil))
      logger.error "Unable to add pdf_file from #{pdflink}"
      work.delete
      return nil
    end

    if (!file.save)
      logger.error "Unable to save basicfile"
      work.delete
      return nil
    end

    rep = SingleFileRepresentation.new
    rep.files << file

    if (!rep.save)
      logger.error "Unable to save file representation"
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