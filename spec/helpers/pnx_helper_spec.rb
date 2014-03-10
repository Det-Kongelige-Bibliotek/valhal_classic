require 'spec_helper'

class DummyClass
end


describe PnxHelper do

  before(:each) do
    @dummy_class = DummyClass.new
    @dummy_class.extend(PnxHelper)
  end

  describe 'parse_response(xml)' do
    it 'should produce an array of record hashes' do
      file = File.read("#{Rails.root}/spec/fixtures/primo_sample_response.xml")
      xml = REXML::Document.new(file)
      response_array = @dummy_class.parse_response(xml)
      response_array.length.should > 0
      response_array[0]['title'].should include('En Formiddag')
    end
  end

end