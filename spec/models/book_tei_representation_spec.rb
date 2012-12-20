require 'spec_helper'

describe BookTeiRepresentation do
  before do
    BookTeiRepresentation.all.each { |book| book.delete }
    @basic_file = create_basic_file(subject)
    subject.files << @basic_file
    subject.book = Book.new
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

  it "should have a relationship to files" do
    subject.files.each { |file| file.should be_kind_of BasicFile }
  end

  it "should be able to be saved" do
    subject.save.should == true
  end

  it "should have a relationship to a book" do
    subject.book.should be_kind_of Book
  end

  it "should be able to retrive the content of the file" do
    book_tei_rep = BookTeiRepresentation.new
    book_tei_rep.save!
    file = create_basic_file(book_tei_rep)
    book_tei_rep.files << file
    book_tei_rep.save
    book = BookTeiRepresentation.find(book_tei_rep.pid)
    puts book.files.inspect
    book.files.first.should == file
  end
end
