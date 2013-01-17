# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Person and Book" do

  describe " author relationship" do
    before(:each) do
      pending "Await other stuff"
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

  describe " with representations" do
    before(:each) do
      @person = Person.create(:name=>"person with representation")
      @person.save!
      @book = Book.create(:title=>"book with representation")
      @book.save!

      @btr = BookTeiRepresentation.new
      @btr.book = @book
      @btr.save!
      @ptr = PersonTeiRepresentation.new
      @ptr.person = @person
      @ptr.save!

      @person.authored_books << @book
      @person.save!
      @book.authors << @person
      @book.save!
    end

    it "should be defined in the Person entity" do
      pending "FIXME: this is not working..."
      @person.authored_books.should_not be_nil
      @person.authored_books.should_not be_empty
      @person.authored_books.length.should == 1
      @person.authored_books.first.should == @book

      @person.tei.should_not be_nil
      @person.tei.should_not be_empty
      @person.tei.length.should == 1
      @person.tei.first.should == @book
    end

    it "should be defined in the Book entity" do
      pending "FIXME: this is not working..."
      @book.authors.should_not be_nil
      @book.authors.should_not be_empty
      @book.authors.length.should == 1
      @book.authors.first.should == @person

      @book.tei.should_not be_nil
      @book.tei.should_not be_empty
      @book.tei.length.should == 1
      @book.tei.first.should == @person
    end

    it "should have relationship from the BookTeiRepresentations point of view" do
      @btr.book.should == @book
      @btr.book.authors.should_not be_nil
      @btr.book.authors.length.should == 1
      @btr.book.authors.first.should == @person
      @btr.book.authors.first.tei.should_not be_nil
      puts @btr.book.authors.first.tei
      @btr.book.authors.first.tei.length.should == 1
      @btr.book.authors.first.tei.first.should == @ptr
    end

    it "should have relationship from the PersonTeiRepresentations point of view" do
      pending "Fix Then other test first"
      @ptr.person.should == @person
      @ptr.person.authored_books.should_not be_nil
      @ptr.person.authored_books.length.should == 1
      @ptr.person.authored_books.first.should == @book
      @ptr.person.authored_books.first.tei.should_not be_nil
      puts @ptr.person.authored_books.first.tei
      @ptr.person.authored_books.first.tei.length.should == 1
      @ptr.person.authored_books.first.tei.first.should == @btr
    end
  end

  after(:all) do
    Book.all.each { |book| book.delete }
    Person.all.each { |person| person.delete }
    BookTeiRepresentation.all.each { |btr| btr.delete }
    PersonTeiRepresentation.all.each { |ptr| ptr.delete }
  end
end
