# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "intellectual_entity" do
  class IntellectualEntity < ActiveFedora::Base
    include Concerns::IntellectualEntity
  end

  it "should be valid with 16 =< uuid_length =<64 " do
    @intellectual_entity = IntellectualEntity.new
    @intellectual_entity.uuid = "abcdabcdabcdabcdh"
    @intellectual_entity.should be_valid
    @intellectual_entity.save.should be_true
    @intellectual_entity.uuid.should == "abcdabcdabcdabcdh"
  end

  it "should not be valid with uuid_length less then 16 " do
    @intellectual_entity = IntellectualEntity.new
    @intellectual_entity.uuid = "abcdabcd"
    @intellectual_entity.should_not be_valid
    @intellectual_entity.save.should be_false
  end

  it "should not be valid with uuid_length more then 64 " do
    @intellectual_entity = IntellectualEntity.new
    @intellectual_entity.uuid = "abcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcd"
    @intellectual_entity.should_not be_valid
    @intellectual_entity.save.should be_false
  end


end