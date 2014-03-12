# -*- encoding : utf-8 -*-
module DigitisationHelper
  require 'services/http_service'
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

  def create_dod_work(message)
    logger.debug 'Going to generate MODS for eBook...'
    aleph_set_number = get_aleph_set_number(message['id'])
  end

  def get_aleph_set_number(barcode)
    aleph_set_number = 0
    #make http request for set number
    aleph_base_uri = 'http://aleph-00.kb.dk/X'
    #parse XML result to get set_number
    http_service = HttpService.new
    aleph_set_number_xml = http_service.do_post(aleph_base_uri, params = {
                                                    "op" => "find",
                                                    "base" => "kgl01",
                                                    "library" => "kgl01",
                                                    "request" => "bar=#{barcode}"})
    logger.debugger aleph_set_number_xml
    puts aleph_set_number_xml
    return aleph_set_number
  end
end