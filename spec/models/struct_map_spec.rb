# -*- encoding : utf-8 -*-
require 'spec_helper'

describe StructMap do

  before(:each) do
    @smap = StructMap.create
    @smap.save
  end

  describe "New" do
      it "should be possible to create and save a structmap" do
        @smap = StructMap.new
        @smap.save.should == true
      end
    end

  it "should be able to retrive a saved object from the repository" do
    smap = StructMap.find(@smap.pid)
    smap.should == @smap
  end

  it "should have the required datastreams" do
    @smap.techMetadata.should be_kind_of Datastreams::MetsStructMap
  end

  describe "Destroy" do
      before do
        @smap = StructMap.new
        @smap.save!
      end
      it "should be possible to delete a structmap" do
        count = StructMap.count
        @smap.destroy
        StructMap.count.should == count - 1
      end
    end

    after (:all) do
      StructMap.all.each { |r| r.destroy }
    end
end
