require 'spec_helper'

describe BookTeiRepresentation do
  before do
    @basic_file = BasicFile.new
    uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'aarrebo_tei_p5_sample.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml"))
    @basic_file.add_file(uploaded_file)
    @basic_file.save
    subject.file = @basic_file
  end

  it "should have a rightsMetadata datastream" do
    subject.rightsMetadata.should be_kind_of Hydra::Datastream::RightsMetadata
  end

  it "should have a descMetadata datastream" do
    subject.descMetadata.should be_kind_of ActiveFedora::Datastream
  end

  it "should have a provMetadata datastream" do
    subject.provMetadata.should be_kind_of ActiveFedora::Datastream
  end

  it "should have a relationship to a file" do
    subject.file.should be_kind_of BasicFile
  end

  it "should be able to be saved" do
    subject.save.should == true
  end

  it "should be able to retrive the content of the file" do
    subject.save
    book = BookTeiRepresentation.find(subject.pid)
    book.file.should == @basic_file
  end
end
