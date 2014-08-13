# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BasicFile do

  subject { BasicFile.new }
  it_behaves_like 'a preservable element'
  it_behaves_like 'an element with administrative metadata'

  context "with a xml basic_files" do
    before do
      @basic_file = BasicFile.new
      @uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'aarrebo_tei_p5_sample.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml"))
      @basic_file.add_file(@uploaded_file, nil)
    end

    it "should have shorthand for adding a basic_files" do
      file = BasicFile.new
      file.add_file(@uploaded_file, nil).should be_true
    end

    it "should have mime type" do
      @basic_file.mime_type.should == "text/xml"
    end

    it "should have the original filename" do
      @basic_file.original_filename.should == "aarrebo_tei_p5_sample.xml"
    end

    it "should have the checksum of the basic_files" do
      @basic_file.checksum.should == "f6d3ea2837d092a1c0f91b09617f9bc1"
    end

    it "should have a uuid" do
      @basic_file.save!
      @basic_file.uuid.should_not be_nil
    end

    it "should be able to be saved in repository with a basic_files attended" do
      @basic_file.save.should be_true
    end

    it "should have the basic_files size" do
      @basic_file.size.should == 141349
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

    it "should have a rightsMetadata datastream" do
      @basic_file.rightsMetadata.should be_kind_of Hydra::Datastream::RightsMetadata
    end

    it "should return false when a object that isnt a basic_files is passed down" do
      @basic_file.add_file("basic_files", nil).should be_false
    end

    it 'should not have a thumbnail' do
      @basic_file.has_thumbnail?.should be_false
    end

    it 'should have a fitsMetadataDatastream with valid content regarding the file metadata' do
      @basic_file.datastreams['fitsMetadata1'].should_not be_nil
      @basic_file.datastreams['fitsMetadata1'].content.should_not be_nil
      expect(@basic_file.datastreams['fitsMetadata1'].content).to include('<fits')
    end
  end

  context "with a png basic_files" do
    before do
      @basic_file = BasicFile.new
      @uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'rails.png', type: 'image/png', tempfile: File.new("#{Rails.root}/spec/fixtures/rails.png"))
      @basic_file.add_file(@uploaded_file, false)
    end

    it "should have shorthand for adding a basic_files" do
      file = BasicFile.new
      file.add_file(@uploaded_file, nil).should be_true
    end

    it "should have mime type" do
      @basic_file.mime_type.should == "image/png"
    end

    it "should have the original filename" do
      @basic_file.original_filename.should == "rails.png"
    end

    it "should have the checksum of the basic_files" do
      @basic_file.checksum.should == "9c0a079bdd7701d7e729bd956823d153"
    end

    it "should have a uuid" do
      @basic_file.save!
      @basic_file.uuid.should_not be_nil
    end

    it "should be able to be saved in repository with a basic_files attended" do
      @basic_file.save.should be_true
    end

    it "should have the basic_files size" do
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

    it "should have a rightsMetadata datastream" do
      @basic_file.rightsMetadata.should be_kind_of Hydra::Datastream::RightsMetadata
    end

    it 'should have the same basic_files-type as mime-type' do
      @basic_file.file_type.should == @basic_file.mime_type
    end

    it 'should have a fitsMetadataDatastream' do
      @basic_file.datastreams['fitsMetadata1'].should_not be_nil
    end

    it 'should have a fitsMetadataDatastream with valid content regarding the file metadata' do
      @basic_file.datastreams['fitsMetadata1'].content.should_not be_nil
      #puts @basic_file.datastreams['fitsMetadata1'].content
      expect(@basic_file.datastreams['fitsMetadata1'].content).to include('<fits')
    end
=begin
  context "with a very big pdf file" do
    before do
      @basic_file = BasicFile.new
      @uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'rails.png', type: 'image/png', tempfile: File.new("#{Rails.root}/spec/fixtures/programming-ruby-1-9-2-0_p1_0.pdf"))
      @basic_file.add_file(@uploaded_file, nil)
    end

    it "should have shorthand for adding a basic_files" do
      file = BasicFile.new
      file.add_file(@uploaded_file, nil).should be_true
    end

    it "should have mime type" do
      @basic_file.mime_type.should == "image/png"
    end

    it "should have the original filename" do
      @basic_file.original_filename.should == "rails.png"
    end

    it "should have the checksum of the basic_files" do
      @basic_file.checksum.should == "a8ed2f03626c51c814b6f4df250d97b2"
    end

    it "should have a uuid" do
      @basic_file.save!
      @basic_file.uuid.should_not be_nil
    end

    it "should be able to be saved in repository with a basic_files attended" do
      @basic_file.save.should be_true
    end

    it "should have the basic_files size" do
      @basic_file.size.should == 9782105
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

    it "should have a rightsMetadata datastream" do
      @basic_file.rightsMetadata.should be_kind_of Hydra::Datastream::RightsMetadata
    end

    it "should return false when a object doesn't support the require methods is passed down" do
      @basic_file.add_file("basic_files", nil).should be_false
    end
=end
  end
  context "fetch file from url" do
    before do
      response_body = File.read("#{Rails.root}/spec/fixtures/testdod.pdf")
      stub_request(:get, "http://www.kb.dk/e-mat/dod/testdod.pdf").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.kb.dk', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => response_body, :headers => {'Content-Type' => 'application/pdf'})
      @basic_file = BasicFile.new
      @basic_file.add_file_from_url("http://www.kb.dk/e-mat/dod/testdod.pdf",true)
    end
    it "should have the right size" do
      @basic_file.size.should == 178850
    end

    it "should have mime type" do
      @basic_file.mime_type.should == "application/pdf"
    end

    it "should have the original filename" do
      @basic_file.original_filename.should == "testdod.pdf"
    end

    it "should have the checksum of the basic_files" do
      @basic_file.checksum.should == "1ff03b3cccdd8d98760ba9f667084de6"
    end

    it "should have a uuid" do
      @basic_file.save!
      @basic_file.uuid.should_not be_nil
    end

    it "should be able to be saved in repository with a basic_files attended" do
      @basic_file.save.should be_true
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

    it "should have a rightsMetadata datastream" do
      @basic_file.rightsMetadata.should be_kind_of Hydra::Datastream::RightsMetadata
    end

    it "should return false when a object that isnt a basic_files is passed down" do
      @basic_file.add_file("basic_files", nil).should be_false
    end

    it 'should not have a thumbnail' do
      @basic_file.has_thumbnail?.should be_false
    end

=begin
    it 'should have a fitsMetadataDatastream with valid content regarding the file metadata' do
      @basic_file.datastreams['fitsMetadata1'].should_not be_nil
      @basic_file.datastreams['fitsMetadata1'].content.should_not be_nil
      expect(@basic_file.datastreams['fitsMetadata1'].content).to include('<fits')
    end
=end

    it "should fail to add file from invalid URL" do
      @b = BasicFile.new
      @b.add_file_from_url("asdfkasædlk",true).should be_false
    end
  end
end
