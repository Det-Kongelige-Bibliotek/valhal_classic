# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'DigitisationHelper' do

  describe 'Create new Work object' do

    before (:each) do
      @response_body = File.read("#{Rails.root}/spec/fixtures/testdod.pdf")
      @mods = File.open('spec/fixtures/mods_digitized_book.xml').read
      stub_request(:get, "http://www.kb.dk/e-mat/dod/testdod.pdf").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.kb.dk', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => @response_body, :headers => {'Content-Type' => 'application/pdf'})
      stub_request(:get, "http://www.kb.dk/e-mat/dod/404.pdf").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.kb.dk', 'User-Agent'=>'Ruby'}).
          to_return(:status => 404, :body => '', :headers => {})
    end

    after (:each) do
      BasicFile.all.each { |file| file.delete }
      Work.all.each { |w| w.delete }
      SingleFileRepresentation.all.each { |rep| rep.delete}
    end

    it "should create a new object with singlefile representation" do
      work = create_work_object(@mods, "http://www.kb.dk/e-mat/dod/testdod.pdf")
      work.should_not be_nil
      work.title.should == 'Er Danmark i Fare?'
      work.work_type.should == 'DOD bog'
      work.single_file_reps.length.should == 1
      rep = work.single_file_reps[0]
      rep.should be_a_kind_of SingleFileRepresentation
      rep.files.length.should == 1
      file = rep.files[0]
      file.should be_a_kind_of BasicFile
      file.datastreams['content'].should_not be nil
    end

    it "should fail to create with invalid pdf Link" do
      work = create_work_object(@mods, "asdfasdfasdf")
      work.should be nil

    end

    it "should fail to create with  pdf Link that do not respond 200" do
      work = create_work_object(@mods,"http://www.kb.dk/e-mat/dod/404.pdf")
      work.should be nil

    end

    it "should not create a duplicate work" do
      #Create first work
      work = create_work_object(@mods,"http://www.kb.dk/e-mat/dod/testdod.pdf")
      work.should_not be_nil
      work.title.should == 'Er Danmark i Fare?'
      work.work_type.should == 'DOD bog'
      work.single_file_reps.length.should == 1
      rep = work.single_file_reps[0]
      rep.should be_a_kind_of SingleFileRepresentation
      rep.files.length.should == 1
      file = rep.files[0]
      file.should be_a_kind_of BasicFile
      file.datastreams['content'].should_not be nil

      #Create duplicate work
      work2 = create_work_object(@mods,"http://www.kb.dk/e-mat/dod/testdod.pdf")
      work2.should be_nil
    end
  end

  describe "#get_aleph_set_number" do
    it "returns an aleph set number" do

      stub_request(:post, "http://aleph-00.kb.dk/X").with(
              :body => {"base"=>"kgl01", "library"=>"kgl01", "op"=>"find",
                                                                    "request"=>"bar=130019448593"},
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                           'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "<?xml version = \"1.0\" encoding = \"UTF-8\"?>
      <find>
        <set_number>109558</set_number>
        <no_records>000000001</no_records>
        <no_entries>000000001</no_entries>
        <session-id>BEKFTICJ6DXNK5JIRHETE88H8F6MSV7956HAHM96797VSFR27N</session-id>
      </find>", :headers => {})


      set_number = get_aleph_set_number('130019448593')
      set_number.should_not be_nil
      expect set_number.eql?('109558')
    end
  end

  describe "#get_aleph_marc_xml" do
    it "returns aleph marc xml for an aleph set number" do

      aleph_test_marc_xml = File.read './spec/fixtures/aleph_marc.xml'
      stub_request(:post, "http://aleph-00.kb.dk/X").
         with(:body => {"format"=>"marc", "op"=>"present", "set_entry"=>"000000001", "set_no"=>"109558"},
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                           'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "#{aleph_test_marc_xml}", :headers => {})

      aleph_marc_xml = get_aleph_marc_xml('109558')
      aleph_marc_xml.should_not be_nil
    end
  end

  describe "#transform_aleph_marc_xml_to_mods" do
    it "returns valid MODS XML" do
      aleph_marc_xml = File.read './spec/fixtures/aleph_marc.xml'
      mods = transform_aleph_marc_xml_to_mods(aleph_marc_xml, 'http://aleph-00.kb.dk/X/130019448593.pdf', '130019448593')

      mods.to_s.should_not be_nil
      mods.should be_kind_of Nokogiri::XML::Document
      expect(mods.root.include? '<mods')
      mods.css('mods originInfo edition').text.should eql '3. Oplag'
      mods.css('mods location physicalLocation').text.should eql '37,-376 8°'
      mods.css('mods identifier').text.should eql '130019448593'

      mods_schema = Nokogiri::XML::Schema(File.read('./spec/fixtures/mods-3-5.xsd'))
      expect(mods_schema.validate(mods)).to be_empty
    end
  end
end