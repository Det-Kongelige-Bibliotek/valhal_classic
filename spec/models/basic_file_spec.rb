# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BasicFile do
  context "save a xml file in file datastream" do
    before do
      BasicFile.all.each { |f| f.delete }
      @basic_file = BasicFile.new
      @uploaded_file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml", 'text/xml')
    end

    it "should have shorthand for adding a file" do
      file = BasicFile.new
      file.add_file(@uploaded_file).should == true
    end

    it "should have mime type" do
      @basic_file.add_file(@uploaded_file)
      @basic_file.mime_type.should == "text/xml"
    end

    it "should have the original filename" do
      @basic_file.add_file(@uploaded_file)
      @basic_file.original_filename.should == "aarrebo_tei_p5_sample.xml"
    end

    it "should have the checksum of the file" do
      @basic_file.add_file(@uploaded_file)
      @basic_file.checksum.should == "25461cfc475ea7abed7736cc88829747"
    end

    it "should have a uuid" do
      pending "depends on the intellectual entity"
    end

    it "should have a timestamp for when the file was created" do
      puts @basic_file.created
    end

    it "should have a timestamp for when the file was last modified" do
      @basic_file.add_file(@uploaded_file)
      @basic_file.last_modified
    end

    it "should have a timestamp for when the file was last accessed" do
      @basic_file.add_file(@uploaded_file)
      @basic_file.last_accessed
    end

    it "should could be saved in repository with a file attended" do
      @basic_file.add_file(@uploaded_file)
      @basic_file.save.should == true
    end
  end

end
