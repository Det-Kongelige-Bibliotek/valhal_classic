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
  end

  after(:all) do
    Book.all.each { |book| book.delete }
    SingleFileRepresentation.all.each { |btr| btr.delete }
  end
end
