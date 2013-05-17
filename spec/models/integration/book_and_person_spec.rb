# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Person and Book" do
  before(:all) do
    ActiveFedora::Base.all.each { |af| af.delete }
  end
  describe " author relationship" do
    before(:each) do
      @person = Person.create(:firstname=>"some name", :lastname=>"some lastname", :date_of_birth => Time.now.nsec.to_s)
      @book = Book.create(:title=>"some title")
      @book.save!
      @person.authored_manifestations << @book
      @person.save!
      @book.authors << @person
      @book.save!
    end
    after(:each) do
      Person.all.each { |p| p.delete }
    end

    it "should be defined in the Person entity" do
      @person.authored_manifestations.should_not be_nil
      @person.authored_manifestations.should_not be_empty
      @person.authored_manifestations.length.should == 1
      @person.authored_manifestations.first.should == @book
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

      @person = Person.new(:firstname=>"some name", :lastname=>"some lastname", :date_of_birth => Time.now.nsec.to_s)
      @book = Book.new(:title=>"book with representation")

      @person.authored_manifestations << @book
      @book.authors << @person

      @ptr = DefaultRepresentation.new
      @person.tei << @ptr
      @btr = DefaultRepresentation.new
      @book.tei << @btr

      @book.save!
      @person.save!
    end
    after(:each) do
      Person.all.each { |p| p.delete }
    end

    it "should be defined in the Person entity" do
      @person.authored_manifestations.should_not be_nil
      @person.authored_manifestations.should_not be_empty
      @person.authored_manifestations.length.should == 1
      @person.authored_manifestations.first.should == @book

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
      @ptr.person.authored_manifestations.should_not be_nil
      @ptr.person.authored_manifestations.length.should == 1
      @ptr.person.authored_manifestations.first.should == @book
      @ptr.person.authored_manifestations.first.tei.should_not be_nil
      @ptr.person.authored_manifestations.first.tei.length.should == 1
      @ptr.person.authored_manifestations.first.tei.first.should == @btr
    end
  end

  describe "many authors" do
    before(:each) do
      @book = Book.create(:title=>"some title")
      @book.save!
    end

    it "should be able to have many authors" do
      person1 = Person.create(:firstname=>"first person", :lastname=>"first lastname", :date_of_birth => Time.now.nsec.to_s)
      person1.save!
      person1.authored_manifestations << @book
      person1.save!
      @book.authors << person1

      person2 = Person.create(:firstname=>"second person", :lastname=>"first lastname", :date_of_birth => Time.now.nsec.to_s)
      person2.save!
      person2.authored_manifestations << @book
      person2.save!
      @book.authors << person2

      person3 = Person.create(:firstname=>"third person", :lastname=>"first lastname", :date_of_birth => Time.now.nsec.to_s)
      person3.save!
      person3.authored_manifestations << @book
      person3.save!
      @book.authors << person3

      person4 = Person.create(:firstname=>"fourth person", :lastname=>"first lastname", :date_of_birth => Time.now.nsec.to_s)
      person4.save!
      person4.authored_manifestations << @book
      person4.save!
      @book.authors << person4

      person5 = Person.create(:firstname=>"fifth person", :lastname=>"first lastname", :date_of_birth => Time.now.nsec.to_s)
      person5.save!
      person5.authored_manifestations << @book
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
