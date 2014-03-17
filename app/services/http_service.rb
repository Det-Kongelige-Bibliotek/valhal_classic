# -*- encoding : utf-8 -*-
require 'net/http'

class HttpService

  def do_post(uri_string, params)

    logger.debug "Base URl = #{uri_string}"
    logger.debug "Params = #{params.to_s}"

    url = URI.parse(uri_string)
    request = Net::HTTP::Post.new(url.path)
    request.set_form_data(params)
    response = Net::HTTP.start(url.host, url.port) { |http| http.request(request) }
    response.body
  end

end