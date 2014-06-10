# -*- encoding : utf-8 -*-
require 'spec_helper'

describe HttpService do

  before do
    HttpService.new
  end

  describe '#get_xml_with_http?' do
    it 'should return a string containing XML from a HTTP request to Aleph' do
      pending "Does not work externally, e.g. on Travis."
      stub_request(:post, "http://aleph-00.kb.dk/X").
         with(:body => {"base"=>"kgl01", "library"=>"kgl01", "op"=>"find", "request"=>"bar=130020101343"},
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "", :headers => {})

      http_service = HttpService.new
      xml_response = http_service.do_post('http://aleph-00.kb.dk/X', params = {"op" => "find",
                                                                               "base" => "kgl01",
                                                                               "library" => "kgl01",
                                                                               "request" => "bar=130020101343"})
      puts xml_response
    end
  end
end
