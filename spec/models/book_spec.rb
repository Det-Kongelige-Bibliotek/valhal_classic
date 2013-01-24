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

  after do
    Book.all.each { |book| book.delete }
    BookTeiRepresentation.all.each { |btr| btr.delete }
    BookTiffRepresentation.all.each { |btr| btr.delete }
    BasicFile.all.each { |bf| bf.delete }
  end

end
