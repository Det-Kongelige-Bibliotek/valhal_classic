require 'spec_helper'

class DummyClass
end


describe PnxHelper do

  before(:each) do
    @dummy_class = DummyClass.new
    @dummy_class.extend(PnxHelper)
  end

  describe 'get config' do
    it 'should read yaml into a hash' do
      config = @dummy_class.get_config
      config['url'].should include "primo-97.kb.dk"
    end
  end

  describe 'parse_response(xml)' do
    it 'should produce an array of record hashes' do
      file = File.read("#{Rails.root}/spec/fixtures/primo_sample_response.xml")
      xml = REXML::Document.new(file)
      response_array = @dummy_class.parse_response(xml)
      response_array.length.should > 0
      response_array[0]['title'].should include('En Formiddag')
      response_array[0]['linktosrc'].should start_with('http')
    end
  end

  describe 'create_queue_message(record_hash)' do
    before(:each) do
      @record_hash = {
          "sourcerecordid"=>"008506563",
          "type"=>"book",
          "title"=>"En Formiddag hos Frederik den Store, historisk Charakteerbillede",
          "creator"=>"Mühlbach, Louise",
          "creationdate"=>"1859",
          "description"=>[
              "Digitalisering 2012 af udgaven: [Kbh.]: Jordans' Forlag, 1859 (188 s.)", "Efter Det Kongelige Biblioteks eksemplar: 57,-458-8°"
          ],
          "language"=>"dan",
          "rights"=>"Adgang: Alle har adgang",
          "lds02"=>"57,-458",
          "lds16"=>"af L. Mühlbach",
          "lds37"=>"57,-458",
          "version"=>"2",
          "linktosrc"=>"http://www.kb.dk/e-mat/dod/130020101343.pdf"
      }
    end
    it 'should create a json message for the ingest queue' do
      message = @dummy_class.create_ingest_message(@record_hash)
      message_hash = JSON.parse(message)
      message_hash.should be_instance_of(Hash)
      message_hash['id'].should include('130020101343')
      message_hash['fileUri'].should include('http://www.kb.dk/e-mat/dod/130020101343.pdf')
      message_hash['workflowId'].should include('DOD')
    end
  end

  describe 'search PNX' do
    before(:each) do
      @dummy_class.get_config
      response_body = File.read("#{Rails.root}/spec/fixtures/primo_sample_response.xml")
      stub_request(
          :get, "http://primo-97.kb.dk:1701/PrimoWebServices/xservice/search/brief?bulkSize=1&indx=1&institution=KGL&onCampus=false&query=any,contains,wbhedod").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'primo-97.kb.dk:1701', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => response_body, :headers => {}
      )
    end

    it 'should return an array of responses' do
      responses = @dummy_class.search_pnx
      responses.should be_a(Array)
      responses.first.should be_a(Net::HTTPResponse)
    end

    it 'should convert responses to queue messages' do
      responses = @dummy_class.search_pnx
      messages = @dummy_class.convert_to_messages(responses)
      messages.should be_a(Array)
      messages.first.should be_a(String)
      message = JSON.parse(messages.first)
      message['id'].should eql '130020101343'
    end

  end
end