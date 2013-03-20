# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Book do

  before(:each) do
    @book = Book.create
    @book.save
  end

  it "should have a rightsMetadata datastream" do
    @book.rightsMetadata.should be_kind_of Hydra::Datastream::RightsMetadata
  end

  it "should have the required datastreams" do
    @book.descMetadata.should be_kind_of Datastreams::BookMods
  end

  it "should have the attributes of an book and support update_attributes" do
    attributes_hash = {
        genre: "ADL bog",
        uuid: "urn:uuid:53246d30-34b4-11e2-81c1-0800200c9a66",
        isbn: "8787504073",
        typeOfResource: "text",
        shelfLocator: "Pligtaflevering",
        title: "Samlede Skrifter",
        subTitle: "Bd. 1",
        publisher: "Det Danske Sprog og Litteraturselskab",
        originPlace: "Copenhagen",
        dateIssued: "2002-10-02T10:00:00-05:00",
        languageISO: "dan",
        languageText: "DANSK",
        subjectTopic: "N8217.H68",
        physicalExtent: "510"
    }

    @book.update_attributes(attributes_hash)

    @book.genre.should == attributes_hash[:genre]
    @book.uuid.should == attributes_hash[:uuid]
    @book.isbn.should == attributes_hash[:isbn]
    @book.typeOfResource.should == attributes_hash[:typeOfResource]
    @book.shelfLocator.should == attributes_hash[:shelfLocator]
    @book.title.should == attributes_hash[:title]
    @book.subTitle.should == attributes_hash[:subTitle]
    @book.publisher.should == attributes_hash[:publisher]
    @book.originPlace.should == attributes_hash[:originPlace]
    @book.dateIssued.should == attributes_hash[:dateIssued]
    @book.languageISO.should == attributes_hash[:languageISO]
    @book.languageText.should == attributes_hash[:languageText]
    @book.subjectTopic.should == attributes_hash[:subjectTopic]
    @book.physicalExtent.should == attributes_hash[:physicalExtent]
  end

  describe "get_title_for_display" do
    it "should deliver both title and subtitle, separated with a comma, when both is present" do
      title = "the title"
      subtitle = "the subTitle"
      @book.title = title
      @book.subTitle = subtitle
      @book.save!

      @book.get_title_for_display.should == title + ", " + subtitle
    end

    it "should only deliver the title, when no subtitle is given" do
      title = "the title"
      subtitle = nil
      @book.title = title
      @book.subTitle = subtitle
      @book.save!

      @book.get_title_for_display.should == title
    end
  end

  describe "authors" do
    it "should not have an author, when noone has been assigned as author" do
      @book.has_author?.should == false
    end

    it "should have an author, when a person has been assigned as author" do
      person = Person.create(:firstname=>"fn", :lastname => "ln")
      @book.authors << person

      @book.has_author?.should == true
    end
  end

  describe "tiff_representation" do
    it "should not have an tiff representation, when noone has been assigned" do
      @book.hasTiffRep?.should == false
    end

    it "should have an tiff representation, when one has been assigned" do
      tiff = BookTiffRepresentation.create
      @book.tif << tiff

      @book.hasTiffRep?.should == true
    end
  end

  describe "tei_representation" do
    it "should not have an tei representation, when noone has been assigned" do
      @book.tei_rep?.should == false
    end

    it "should have an tei representation, when one has been assigned" do
      tei = BookTeiRepresentation.create
      @book.tei << tei

      @book.tei_rep?.should == true
    end
  end

  #For the tests involving ISBNs you need to make sure the ISBNs are unique, otherwise the Book will fail to save as it
  #will be invalid, unless you are testing for duplicate ISBNs deliberately
  describe "validation" do

    it "does not accept books without titles" do
      book_with_no_title = Book.new
      book_with_no_title.valid?.should be_false
    end

    it "accepts books with titles" do
      book_with_title = Book.new(:title => "The Brothers Karamazov")
      book_with_title.valid?.should be_true
    end

    it "does not accept non-numeric values for ISBN" do
      @book.isbn = "xyz12312xyz"
      @book.valid?.should be_false
    end

    it "accepts numeric values for ISBN" do
      book = Book.new(:title => "XYZ", :isbn => 9788175257662)
      book.valid?.should be_true
    end

    it "accepts blank ISBNs" do
      book = Book.new(:title => "Howard's End")
      book.valid?.should be_true
    end

    it "does allow creation of two books one with an ISBN and one without" do
      book1 = Book.new(:title => "København Blues", :isbn => 9788175237665)
      book2 = Book.new(:title => "Belfast Blues")
      book2.valid?.should be_true
    end

    it "does not allow creation of two books with the same ISBN" do
      first_book = Book.new(:title => "Java in a Nutshell", :isbn => 9788175257665)
      first_book.save!
      duplicate_book = Book.new(:title => "MITRE", :isbn => 9788175257665)
      expect { duplicate_book.save! }.to raise_error(ActiveFedora::RecordInvalid, /Isbn cannot be duplicated/)
    end

    it "does allow creation of two books with different ISBNs" do
      first_book = Book.new(:title => "Java in a Nutshell", :isbn => 9788175257661)
      first_book.save!
      duplicate_book = Book.new(:title => "MITRE", :isbn => 9788175257666)
      expect { duplicate_book.save! }.to_not raise_error(ActiveFedora::RecordInvalid, /Isbn cannot be duplicated/)
    end
  end

  after(:all) do
    Book.all.each { |book| book.delete }
    BookTeiRepresentation.all.each { |btr| btr.delete }
    BookTiffRepresentation.all.each { |btr| btr.delete }
    BasicFile.all.each { |bf| bf.delete }
  end

end
