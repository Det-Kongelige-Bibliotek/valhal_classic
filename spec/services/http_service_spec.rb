# -*- encoding : utf-8 -*-

require 'services/http_service'
describe HttpService do

  before do
    HttpService.new
  end

  describe '#get_xml_with_http?' do
    it 'should return a string containing XML from a HTTP request to Aleph' do
      http_service = HttpService.new
      xml_response = http_service.do_post('http://aleph-00.kb.dk/X', params = {"op" => "find",
                                                                               "base" => "kgl01",
                                                                               "library" => "kgl01",
                                                                               "request" => "bar=130020101343"})
      puts xml_response
    end
  end
end