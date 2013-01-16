# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Person and Book" do

  describe " author relationship" do
    before(:each) do
      @person = Person.create(:name=>"some name")
      @person.save!
      @book = Book.create(:title=>"some title")
      @book.save!
      @person.authored_books << @book
      @person.save!
      @book.authors << @person
      @book.save!
    end

    it "should be defined in the Person entity" do
      @person.authored_books.should_not be_nil
      @person.authored_books.should_not be_empty
      @person.authored_books.length.should == 1
      @person.authored_books.first.should == @book
    end

    it "should be defined in the Book entity" do
      @book.authors.should_not be_nil
      @book.authors.should_not be_empty
      @book.authors.length.should == 1
      @book.authors.first.should == @person
    end
  end

  after do
    Book.all.each { |book| book.delete }
    Person.all.each { |person| person.delete }
  end
end
