# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Datastreams::MetsStructMap do

  before(:each) do
    @mets_structmap = fixture("aarebo_mets_structmap_sample.xml")
    @ds = Datastreams::MetsStructMap.from_xml(@mets_structmap)
  end

  it "should have a structMap element" do
    @ds.node_exists?(:structMap)
  end

  it "should have 6 div elements underneath the structMap element" do
    @ds.find_by_terms(:div).length.should == 6
  end

  it "should have 6 fptr elements" do
    @ds.find_by_terms(:fptr).length.should == 6
  end

  it "each fptr element should have a FILEID attribute" do
    @ds.find_by_terms(:file_id).length.should == 6
  end

  it "the first fptr element should have a FILEID attribute with value arre1fm001.tif" do
    @ds.find_by_terms(:file_id).first.content == "arre1fm001.tif"
  end

  it "the last fptr element should have a FILEID attribute with value arre1fm006.tif" do
    @ds.find_by_terms(:file_id).last.content == "arre1fm006.tif"
  end

  it "the first div element should have an order attribute with a value of 1" do
    @ds.find_by_terms(:order).first.content == "1"
  end

  it "the last div element should have an order attribute with a value of 6" do
    @ds.find_by_terms(:order).last.content == "6"
  end

  it "should have 6 basic_files ids" do
    @ds.term_values(:file_id).length.should == 6
  end

  it "should be possible to update the last value to something new" do
    @ds.term_value_update(:file_id, 5, "test.tif")
    @ds.find_by_terms(:file_id).last.content == "test.tif"
  end

  it "should be possible to create a new structmap" do
    new_mets_structmap = Datastreams::MetsStructMap.new
    #new_mets_structmap.save
    new_mets_structmap.should_not be_nil
  end

end