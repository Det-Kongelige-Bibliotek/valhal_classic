# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Datastreams::BookMods do

  before(:each) do
    @bookmods = fixture("samlede_skrifter_bd_1_arrebo_mods_sample.xml")
    @ds = Datastreams::BookMods.from_xml(@bookmods)
  end

  it "should expose book information" do
    @ds.mods.genre.should == ["ADL bog"]
    @ds.mods.uuid.should == ["urn:uuid:53246d30-34b4-11e2-81c1-0800200c9a66"]
    @ds.mods.local_id.should == ["180"]
    @ds.mods.location.shelfLocator.should == ["Pligtaflevering"]
    @ds.mods.titleInfo.title.should == ["Samlede Skrifter Bd. 1"]
  end
end