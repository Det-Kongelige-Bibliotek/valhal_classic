# -*- encoding : utf-8 -*-
require 'spec_helper'

describe IntellectualEntity do
  describe "#new" do
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

    it "should be possible to update with a different uuid" do
      @intellectual_entity = IntellectualEntity.new
      @intellectual_entity.uuid = "asdf-fdsa-asdf-dfsa"
      @intellectual_entity.save!
      @intellectual_entity.uuid = "1234-5678-1234-5768"
      @intellectual_entity.save!
      @intellectual_entity.uuid.should == "1234-5678-1234-5768"
    end

    it "should be possible to find through the uuid" do
      pending "??"
      @intellectual_entity = IntellectualEntity.new
      @intellectual_entity.save!
      uuid = @intellectual_entity.uuid
      IntellectualEntity.find_with_conditions(:uuid => uuid).should_not be_empty
    end

    it "should be possible to identify as an ActiveFedora object" do
      @intellectual_entity = IntellectualEntity.new
      @intellectual_entity.save!
      ActiveFedora::Base.find_with_conditions(:id => @intellectual_entity.pid).first["id"].should == @intellectual_entity.pid
      @intellectual_entity.should be_kind_of ActiveFedora::Base
    end
  end

  describe "#destroy" do
    it "should be an instance of ActiveFedora" do
      @intellectual_entity = IntellectualEntity.new
      @intellectual_entity.save!
      pid = @intellectual_entity.pid
      @intellectual_entity.destroy
      ActiveFedora::Base.find_with_conditions(:id => pid).should be_empty
    end

    it "should be possible to destroy an object" do
      pending "Cannot find intellectual entity from uuid"
      @intellectual_entity = IntellectualEntity.new
      @intellectual_entity.save!
      uuid = @intellectual_entity.uuid
      @intellectual_entity.destroy
      IntellectualEntity.find_with_conditions(:uuid => uuid).should be_empty
    end
  end

end
