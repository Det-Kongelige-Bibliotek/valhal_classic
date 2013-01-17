# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Book do

  # tests for the relationship between the Book and the BookTeiRepresentation
  describe " - BookTeiRepresentation relationship" do
    before(:each) do
      @book = Book.create
      @book.save
      @tei = BookTeiRepresentation.new
      @tei.book = @book
      @tei.save!
    end

    it "should be defined in the Book entity" do
      @book.tei.should_not be_nil
      @book.tei.should_not be_empty
      @book.tei.length.should == 1
      @book.tei.first.should == @tei
    end

    it "should be defined in the BookTeiRepresentation entity" do
      @tei.book.should_not be_nil
      @tei.book.should == @book
      @tei.book.tei.first.should == @tei
    end
  end

  after do
    Book.all.each { |book| book.delete }
    BookTeiRepresentation.all.each { |btr| btr.delete }
  end
end
