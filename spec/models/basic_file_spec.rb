# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BasicFile do
  context "with a xml file" do
    before do
      @basic_file = BasicFile.new
      @uploaded_file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml", 'text/xml')
      @basic_file.add_file(@uploaded_file)
    end

    it "should have shorthand for adding a file" do
      file = BasicFile.new
      file.add_file(@uploaded_file).should == true
    end

    it "should have mime type" do
      @basic_file.mime_type.should == "text/xml"
    end

    it "should have the original filename" do
      @basic_file.original_filename.should == "aarrebo_tei_p5_sample.xml"
    end

    it "should have the checksum of the file" do
      @basic_file.checksum.should == "25461cfc475ea7abed7736cc88829747"
    end

    it "should have a uuid" do
      pending "depends on the intellectual entity"
      @basic_file.uuid.should == "something"
    end

    it "should have a timestamp for when the file was created" do
      @basic_file.created.should be_kind_of String
    end

    it "should have a timestamp for when the file was last modified" do
      @basic_file.last_modified.should be_kind_of String
    end

    it "should have a timestamp for when the file was last accessed" do
      @basic_file.last_accessed.should be_kind_of String
    end

    it "should be able to be saved in repository with a file attended" do
      @basic_file.save.should == true
    end

    it "should have the file size" do
      @basic_file.size.should == 1073687
    end

    it "should have a description" do
      @basic_file.description = "description"
      @basic_file.description.should == "description"
    end

    it "should be able to retrive a saved object from the repository" do
      @basic_file.save

      file = BasicFile.find(@basic_file.pid)
      file.should == @basic_file
    end

    it "should have a descMetadata datastream" do
      @basic_file.descMetadata.should be_kind_of ActiveFedora::Datastream
    end

    it "should have a techMetadata datastream" do
      @basic_file.techMetadata.should be_kind_of ActiveFedora::Datastream
    end

    it "should have a content datastream" do
      @basic_file.content.should be_kind_of ActiveFedora::Datastream
    end

    it "should return false when a object that isnt a file is passed down" do
      @basic_file.add_file("file").should == false
    end

  end
  context "with a png file" do
    before do
      @basic_file = BasicFile.new
      @uploaded_file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/rails.png", 'image/png')
      @basic_file.add_file(@uploaded_file)
    end

    it "should have shorthand for adding a file" do
      file = BasicFile.new
      file.add_file(@uploaded_file).should == true
    end

    it "should have mime type" do
      @basic_file.mime_type.should == "image/png"
    end

    it "should have the original filename" do
      @basic_file.original_filename.should == "rails.png"
    end

    it "should have the checksum of the file" do
      @basic_file.checksum.should == "9c0a079bdd7701d7e729bd956823d153"
    end

    it "should have a uuid" do
      pending "depends on the intellectual entity"
      @basic_file.uuid.should == "something"
    end

    it "should have a timestamp for when the file was created" do
      @basic_file.created.should be_kind_of String
    end

    it "should have a timestamp for when the file was last modified" do
      @basic_file.last_modified.should be_kind_of String
    end

    it "should have a timestamp for when the file was last accessed" do
      @basic_file.last_accessed.should be_kind_of String
    end

    it "should be able to be saved in repository with a file attended" do
      @basic_file.save.should == true
    end

    it "should have the file size" do
      @basic_file.size.should == 6646
    end

    it "should have a description" do
      @basic_file.description = "description"
      @basic_file.description.should == "description"
    end

    it "should be able to retrive a saved object from the repository" do
      @basic_file.save

      file = BasicFile.find(@basic_file.pid)
      file.should == @basic_file
    end

    it "should have a descMetadata datastream" do
      @basic_file.descMetadata.should be_kind_of ActiveFedora::Datastream
    end

    it "should have a techMetadata datastream" do
      @basic_file.techMetadata.should be_kind_of ActiveFedora::Datastream
    end

    it "should have a content datastream" do
      @basic_file.content.should be_kind_of ActiveFedora::Datastream
    end

    it "should return false when a object doesn't support the require methods is passed down" do
      @basic_file.add_file("file").should == false
    end
  end

end
