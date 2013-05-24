# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Book do
  before(:all) do
    Book.all.each { |book| book.delete }
  end

  # tests for the relationship between the Book and the BookTeiRepresentation
  describe " - DefaultRepresentation relationship" do
    before(:each) do

      @book = Book.new(:title => "My First Book")
      @tei = SingleFileRepresentation.new
      @book.representations << @tei
      @book.save!
    end

    it "should be defined in the Book entity" do
      @book.representations.should_not be_nil
      @book.representations.should_not be_empty
      @book.representations.length.should == 1
      @book.representations.first.should == @tei
    end

    it "should be defined in the DefaultRepresentation entity" do
      @tei.book.should_not be_nil
      @tei.book.should == @book
      @tei.book.representations.first.should == @tei
    end

    it "should be able to have more then one TEI file" do
      @tei2 = DefaultRepresentation.new
      @book.tei << @tei2
      @book.tei.length.should == 2
    end

    it "should retrieve file after save" do
      @book2 = Book.find(@book.pid)
      @book2.tei.should include @tei
    end

    it "should be able to contain XML file"  do
      @tif = OrderedRepresentation.new
      @book.tif << @tif
      @book.save!
    end



  end

  after(:all) do
    Book.all.each { |book| book.delete }
    SingleFileRepresentation.all.each { |btr| btr.delete }
  end
end
