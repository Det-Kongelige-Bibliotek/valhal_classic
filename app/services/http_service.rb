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
  #    request = Net::HTTP::Post.new(url.path)
  #    request.set_form_data(params)
  #    http = Net::HTTP.new(url.host, url.port)
  #    http.read_timeout = 5000
      logger.debug "http start"
  #    logger.debug "#{http.inspect}"
  #    response = Net::HTTP.start(url.host, url.port) { |http|  http.request(request) }
  #    response = http.request(request)
      logger.debug "HttpService: num_of_threads = #{Thread.current.group.list.size}"
      if Thread.current.group.list.size > 1
        Thread.current.group.list.each do |thread|
          logger.debug thread.inspect
        end
      end
      response = HTTParty.post(uri_string, :body => params)
      puts response.body, response.code, response.message, response.headers.inspect
      logger.debug "got response #{response.inspect}"
    rescue Exception  => e
      logger.error "do_post failed #{uri_string}: #{e.message}"
      logger.error e.backtrace.join("\n")
    end
    response.body
  end
end