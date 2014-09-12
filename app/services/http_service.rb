# -*- encoding : utf-8 -*-
require 'net/http'
require 'httparty'

class HttpService

  def do_post(uri_string, params)

    logger.debug "Base URl = #{uri_string}"
    logger.debug "Params = #{params.to_s}"
    response = false
    begin
      url = URI.parse(uri_string)
      logger.debug "http start"
      response = HTTParty.post(uri_string, :body => params)
    rescue Exception  => e
      logger.error "do_post failed #{uri_string}: #{e.message}"
      logger.error e.backtrace.join("\n")
    end
    response ? response.body : response
  end
end
