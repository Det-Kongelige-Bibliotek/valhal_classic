require 'spec_helper'

  describe "#find_set_number" do

    before(:each) do
      @service = AlephService.new
    end

    it "returns an aleph set number" do
      pending "Failing..."

      stub_request(:post, "http://aleph-test-00.kb.dk/X").with(
          :body => {"base"=>"kgl01", "library"=>"kgl01", "op"=>"find",
                    "request"=>"wbh=edod"},
          :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                       'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "<?xml version = \"1.0\" encoding = \"UTF-8\"?>
      <find>
        <set_number>109558</set_number>
        <no_records>000000001</no_records>
        <no_entries>000005000</no_entries>
        <session-id>BEKFTICJ6DXNK5JIRHETE88H8F6MSV7956HAHM96797VSFR27N</session-id>
      </find>", :headers => {})


      set_number = @service.find_set('wbh=edod')
      set_number.should_not be_nil
      puts set_number.class.to_s
      expect set_number[:set_num].eql?('109558')
      expect set_number[:num_entries].eql?('5000')
    end

    it 'should convert a digital record into a queue message' do
      record = fixture('aleph_dig_record.xml')
      message = @service.convert_marc_to_message(record.read)
      message.should be_a String
      message_hash = JSON.parse(message)
      message_hash['id'].should eql '001955976'
      message_hash['fileUri'].should eql 'http://www.kb.dk/e-mat/dod/130020834545.pdf'
      message_hash['workflowId'].should eql 'DOD'
    end

    it 'should convert another digital record into a queue message' do
      record = fixture('aleph_dig_record_fail.xml')
      message = @service.convert_marc_to_message(record.read)
      message.should be_a String
      message_hash = JSON.parse(message)
      message_hash['id'].should eql '002079046'
      message_hash['fileUri'].should eql 'http://www.kb.dk/e-mat/dod/11060802747F.pdf'
      message_hash['workflowId'].should eql 'DOD'
    end

    describe "#get_record" do
      it "returns aleph marc xml for an aleph set number and entry number" do
#        pending "Failing..."

        aleph_test_marc_xml = File.read './spec/fixtures/aleph_marc.xml'
        stub_request(:post, "http://aleph-test-00.kb.dk/X").
            with(:body => {"format"=>"marc", "op"=>"present", "set_entry"=>"000000001", "set_no"=>"109558"},
                 :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                              'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => "#{aleph_test_marc_xml}", :headers => {})

        aleph_marc_xml = @service.get_record('109558', '000000001')
        aleph_marc_xml.should_not be_nil
      end
    end
end
