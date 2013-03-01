# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BookTiffRepresentation do
  before do
    BookTiffRepresentation.all.each { |book| book.delete }
    @basic_file = create_basic_file_for_tif(subject)
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

  it "should be able to retrieve the content of the file" do
    book_tiff_rep = BookTiffRepresentation.new
    book_tiff_rep.save!
    file = create_basic_file_for_tif(book_tiff_rep)
    book_tiff_rep.files << file
    book_tiff_rep.save
    btr = BookTiffRepresentation.find(book_tiff_rep.pid)
    btr.files.first.should == file
  end

  describe "#create" do
    it "should be created without arguments" do
      bfr = BookTiffRepresentation.new
      bfr.save.should == true
    end
  end

  describe "#update" do
    before do
      @bfr = BookTiffRepresentation.new()
      @bfr.save!
    end
  end

  describe "#delete" do
    before do
      @bfr = BookTiffRepresentation.new()
      @bfr.save!
    end

    it "should be possible to delete" do
      count = BookTiffRepresentation.count
      @bfr.destroy
      BookTiffRepresentation.count.should == count-1
    end
  end

  after do
    Book.all.each { |book| book.delete }
    BookTiffRepresentation.all.each { |btr| btr.delete }
    BookTiffRepresentation.all.each { |btr| btr.delete }
    BasicFile.all.each { |bf| bf.delete }
  end

end
