# -*- encoding : utf-8 -*-
require 'spec_helper'

describe IntellectualEntity do
  it "should not be valid with an single letter value for the uuid" do
    @intellectual_entity = IntellectualEntity.new
    @intellectual_entity.uuid = "e"
    @intellectual_entity.should_not be_valid
    @intellectual_entity.save.should be_false
  end

  it "should be valid with an longer string value for the uuid" do
    @intellectual_entity = IntellectualEntity.new
    @intellectual_entity.uuid = "asdf-fdsa-asdf-dfsa"
    @intellectual_entity.should be_valid
    @intellectual_entity.save.should be_true
    @intellectual_entity.uuid.should == "asdf-fdsa-asdf-dfsa"
  end

  it "should be able to be saved" do
    @intellectual_entity = IntellectualEntity.new
    @intellectual_entity.save.should be_true
  end

  it "should be appointed a uuid when saved, if the uuid is missing" do
    @intellectual_entity = IntellectualEntity.new
    @intellectual_entity.uuid.should be_nil
    @intellectual_entity.save!
    @intellectual_entity.uuid.should_not be_nil
  end

  it "should have the uuid in the format of a string" do
    @intellectual_entity = IntellectualEntity.new
    @intellectual_entity.save!
    @intellectual_entity.uuid.should be_kind_of String
  end

end
