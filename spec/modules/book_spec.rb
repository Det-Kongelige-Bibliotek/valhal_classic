# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Book do

  before(:each) do
    @book = Book.create
  end

  it "should have the required datastreams" do
    @book.descMetadata.should be_kind_of Datastreams::BookModsDatastream
  end

  it "should have the attributes of an book and support update_attributes" do
    attributes_hash = {
        genre: "ADL bog",
        uuid: "urn:uuid:53246d30-34b4-11e2-81c1-0800200c9a66",
        local_id: "180",
        shelfLocator: "Pligtaflevering",
        title: "Samlede Skrifter Bd. 1"
    }

    @book.update_attributes(attributes_hash)

    @book.genre.should == attributes_hash[:genre]
    @book.uuid.should == attributes_hash[:uuid]
    @book.local_id.should == attributes_hash[:local_id]
    @book.shelfLocator.should == attributes_hash[:shelfLocator]
    @book.title.should == attributes_hash[:title]
  end

  after(:each) do
    @book.delete
  end
end
