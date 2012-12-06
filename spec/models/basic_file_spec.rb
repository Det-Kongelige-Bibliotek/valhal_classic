# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BasicFile do
  context "user have uploaded an xml file" do
    before do
      BasicFile.all.each { |f| f.delete }
      @basic_file = BasicFile.new
      @uploaded_file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml", 'text/xml')
    end

    it "should have shorthand for add a file" do
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
      @basic_file.checksum.should == "44932ea8c9a90a04af0d76f90517bd0cf86a568206183181b2aa65d1deaba3af"
    end

    it "should have a uuid" do
      pending "depends on the intellectual entity"
    end

    it "should have a timestamp for when the file was created" do
      pending "TODO make sense of this test"
      @basic_file.add_file(@uploaded_file)
      @basic_file.created
    end

    it "should have a timestamp for when the file was last modified" do
      pending "TODO make sense of this test"
      @basic_file.add_file(@uploaded_file)
      @basic_file.last_modified
    end

    it "should have a timestamp for when the file was last accessed" do
      pending "TODO make sense of this test"
      @basic_file.add_file(@uploaded_file)
      @basic_file.last_accessed
    end

    it "should could be saved in repository with a file attended" do
      pending "fails at the momut"
      @basic_file.add_file(@uploaded_file)
      @basic_file.save.should == true
    end
  end

end
