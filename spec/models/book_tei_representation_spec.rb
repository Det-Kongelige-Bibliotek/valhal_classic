# -*- encoding : utf-8 -*-
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

  it "should be able to retrieve the content of the file" do
    book_tei_rep = BookTeiRepresentation.new
    book_tei_rep.save!
    file = create_basic_file(book_tei_rep)
    book_tei_rep.files << file
    book_tei_rep.save
    btr = BookTeiRepresentation.find(book_tei_rep.pid)
    btr.files.first.should == file
  end

  describe "#create" do
    it "should be created without arguments" do
      bfr = BookTeiRepresentation.new
      bfr.save.should == true
    end

    it "should be created directly with a tei version" do
      bfr = BookTeiRepresentation.new(tei_version:"TEI-P4")
      bfr.save!
    end

    it "should be created when given a tei version" do
      bfr = BookTeiRepresentation.new
      bfr.tei_version = "TEI-P4"
      bfr.save.should == true
    end
  end

  describe "#update" do
    before do
      @bfr = BookTeiRepresentation.new(tei_version:"TEI-P4")
      @bfr.save!
    end

    it "should be possible to update the tei version" do
      @bfr.tei_version = "TEI-P5"
      @bfr.save!
      bfr1 = BookTeiRepresentation.find(@bfr.pid)
      bfr1.tei_version.should == "TEI-P5"
    end
  end

  describe "#delete" do
    before do
      @bfr = BookTeiRepresentation.new(tei_version:"TEI-P4")
      @bfr.save!
    end

    it "should be possible to delete" do
      count = BookTeiRepresentation.count
      @bfr.destroy
      BookTeiRepresentation.count.should == count-1
    end
  end

  after do
    Book.all.each { |book| book.delete }
    BookTeiRepresentation.all.each { |btr| btr.delete }
    BookTiffRepresentation.all.each { |btr| btr.delete }
    BasicFile.all.each { |bf| bf.delete }
  end

end
