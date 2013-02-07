# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Person and Book" do
  before(:all) do
    Book.all.each { |book| book.delete }
    Person.all.each { |person| person.delete }
    BookTeiRepresentation.all.each { |btr| btr.delete }
    PersonTeiRepresentation.all.each { |ptr| ptr.delete }
  end
  describe " author relationship" do
    before(:each) do
      @person = Person.create(:firstname=>"some name")
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

      @person = Person.create(:firstname=>"person with representation")
      @person.save!
      @book = Book.create(:title=>"book with representation")
      @book.save!

      @ptr = PersonTeiRepresentation.new
      @ptr.person = @person
      @ptr.save!
      @btr = BookTeiRepresentation.new
      @btr.book = @book
      @btr.save!

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

      @person.tei.should_not be_nil
      @person.tei.should_not be_empty
      @person.tei.length.should == 1
      @person.tei.first.should == @ptr
    end

    it "should be defined in the Book entity" do
      @book.authors.should_not be_nil
      @book.authors.should_not be_empty
      @book.authors.length.should == 1
      @book.authors.first.should == @person

      @book.tei.should_not be_nil
      @book.tei.should_not be_empty
      @book.tei.length.should == 1
      @book.tei.first.should == @btr
    end

    it "should have relationship from the BookTeiRepresentations point of view" do
      @btr.book.should == @book
      @btr.book.authors.should_not be_nil
      @btr.book.authors.length.should == 1
      @btr.book.authors.first.should == @person
      @btr.book.authors.first.tei.should_not be_nil
      @btr.book.authors.first.tei.length.should == 1
      @btr.book.authors.first.tei.first.should == @ptr
    end

    it "should have relationship from the PersonTeiRepresentations point of view" do
      @ptr.person.should == @person
      @ptr.person.authored_books.should_not be_nil
      @ptr.person.authored_books.length.should == 1
      @ptr.person.authored_books.first.should == @book
      @ptr.person.authored_books.first.tei.should_not be_nil
      @ptr.person.authored_books.first.tei.length.should == 1
      @ptr.person.authored_books.first.tei.first.should == @btr
    end
  end

  describe "many authors" do
    before(:each) do
      @book = Book.create(:title=>"some title")
      @book.save!
    end

    it "should be able to have many authors" do
      person1 = Person.create(:firstname=>"first person")
      person1.save!
      person1.authored_books << @book
      person1.save!
      @book.authors << person1

      person2 = Person.create(:firstname=>"second person")
      person2.save!
      person2.authored_books << @book
      person2.save!
      @book.authors << person2

      person3 = Person.create(:firstname=>"third person")
      person3.save!
      person3.authored_books << @book
      person3.save!
      @book.authors << person3

      person4 = Person.create(:firstname=>"fourth person")
      person4.save!
      person4.authored_books << @book
      person4.save!
      @book.authors << person4

      person5 = Person.create(:firstname=>"fifth person")
      person5.save!
      person5.authored_books << @book
      person5.save!
      @book.authors << person5

      @book.save!

      @book.authors.length.should == 5
      person1.authored_books.length.should == 1
      person1.authored_books.first.should == @book
      person2.authored_books.length.should == 1
      person2.authored_books.first.should == @book
      person3.authored_books.length.should == 1
      person3.authored_books.first.should == @book
      person4.authored_books.length.should == 1
      person4.authored_books.first.should == @book
      person5.authored_books.length.should == 1
      person5.authored_books.first.should == @book
    end
  end
end
