# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'DigitisationHelper' do

  describe 'Create new Work object' do

    before (:each) do
      pending "Failing when running externally - e.g. on Travis"
      @response_body = File.read("#{Rails.root}/spec/fixtures/testdod.pdf")
      @mods = File.open('spec/fixtures/mods_digitized_book.xml').read
      stub_request(:get, "http://www.kb.dk/e-mat/dod/testdod.pdf").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.kb.dk', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => @response_body, :headers => {'Content-Type' => 'application/pdf'})
      stub_request(:get, "http://www.kb.dk/e-mat/dod/404.pdf").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.kb.dk', 'User-Agent'=>'Ruby'}).
          to_return(:status => 404, :body => '', :headers => {})
      @work = update_or_create_work('notanid', @mods, "http://www.kb.dk/e-mat/dod/testdod.pdf")
    end

    after (:each) do
      BasicFile.all.each { |file| file.delete }
      Work.all.each { |w| w.delete }
      SingleFileInstance.all.each { |rep| rep.delete}
    end

    it "should create a new object with singlefile representation" do
      @work = update_or_create_work('notanid', @mods, "http://www.kb.dk/e-mat/dod/testdod.pdf")
      @work.should_not be_nil
      @work.title.should == 'Er Danmark i Fare?'
      @work.work_type.should == 'DOD bog'
      @work.single_file_instances.length.should == 1
      rep = @work.single_file_instances[0]
      rep.should be_a_kind_of SingleFileInstance
      rep.files.length.should == 1
      file = rep.files[0]
      file.should be_a_kind_of BasicFile
      file.datastreams['content'].should_not be nil
    end

    it "should fail to create with invalid pdf Link" do
      work = update_or_create_work('stillnotanid', @mods, "asdfasdfasdf")
      work.should be nil
    end

    it "should fail to create with pdf Link that do not respond 200" do
      work = update_or_create_work('notanid', @mods,"http://www.kb.dk/e-mat/dod/404.pdf")
      work.should be nil

    end

    it "should not create a duplicate work" do
      #Create first work
      @work = update_or_create_work('notanid', @mods,"http://www.kb.dk/e-mat/dod/testdod.pdf")
      @work.should_not be_nil
      @work.title.should == 'Er Danmark i Fare?'
      @work.work_type.should == 'DOD bog'
      @work.single_file_instances.length.should == 1
      rep = @work.single_file_instances[0]
      rep.should be_a_kind_of SingleFileInstance
      rep.files.length.should == 1
      file = rep.files[0]
      file.should be_a_kind_of BasicFile
      file.datastreams['content'].should_not be nil
    end

    it 'should have a value in the shelfLocation that matches the value for <physicalLocation> in the MODS XML' do
      @work = update_or_create_work('notanid', @mods, "http://www.kb.dk/e-mat/dod/testdod.pdf")
      Nokogiri::XML.parse(@mods).css('mods location physicalLocation').text.should eql @work.shelfLocator
    end
  end

  describe "#transform_aleph_marc_xml_to_mods" do
    it "returns valid MODS XML with required data populated" do
      aleph_marc_xml = File.read './spec/fixtures/aleph_marc.xml'
      mods = transform_aleph_marc_xml_to_mods(aleph_marc_xml, 'http://aleph-00.kb.dk/X/130019448593.pdf', '130019448593')

      mods.to_s.should_not be_nil
      mods.should be_kind_of Nokogiri::XML::Document
      expect(mods.root.include? '<mods')
      mods.css('mods originInfo edition').text.should eql '3. Oplag'
      mods.css('mods location physicalLocation').text.should eql '37,-376 8°'
      mods.css('mods recordInfo recordIdentifier').text.should eql '130019448593'
      mods.css('mods language').text.should eql 'dan'

      mods_schema = Nokogiri::XML::Schema(File.read('./spec/fixtures/mods-3-5.xsd'))
      expect(mods_schema.validate(mods)).to be_empty
    end
  end
end
