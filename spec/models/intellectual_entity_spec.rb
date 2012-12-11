require 'spec_helper'

describe IntellectualEntity do

  before do
    @ie = IntellectualEntity.new
  end

  it "should create be able to be saved" do
    @ie.save
  end

  it "should create have a UUID" do
    @ie.uuid = "asdf-fdsa-asdf-fdsa"
    @ie.uuid.should == "asdf-fdsa-asdf-fdsa"
  end
end
