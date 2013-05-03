# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Datastreams::BookMods do

  before(:each) do
    @bookmods = fixture("samlede_skrifter_bd_1_arrebo_mods_sample.xml")
    @ds = Datastreams::BookMods.from_xml(@bookmods)
  end

  it "should expose book information" do
    @ds.mods.genre.should == ["Valhal bog"]
    @ds.mods.uuid.should == ["urn:uuid:53246d30-34b4-11e2-81c1-0800200c9a66"]
    @ds.mods.isbn.should == ["8787504073"]
    @ds.mods.typeOfResource.should == ["text"]
    @ds.mods.location.shelfLocator.should == ["Pligtaflevering"]
    @ds.mods.titleInfo.title.should == ["Samlede Skrifter"]
    @ds.mods.titleInfo.subTitle.should == ["Bd. 1"]
    @ds.mods.originInfo.publisher.should == ["Det Danske Sprog og Litteraturselskab"]
    @ds.mods.originInfo.place.placeTerm.should == ["Copenhagen"]
    @ds.mods.originInfo.dateIssued.should == ["2002-10-02T10:00:00-05:00"]
    @ds.mods.language.languageISO.should == ["dan"]
    @ds.mods.language.languageText.should == ["DANSK"]
    @ds.mods.subject.topic.should == ["N8217.H68"]
    @ds.mods.physicalDescription.extent.should == ["510"]
  end
end