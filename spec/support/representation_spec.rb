# -*- encoding : utf-8 -*-
require 'spec_helper'

class Representation < ActiveFedora::Base
  include Concerns::Representation
end

describe "representation" do
  it "should create a representation with label" do
    represent = Representation.new(:label=>"new label")
    represent.save.should be_true
    represent.label.should == "new label"
  end

  it "should create a representation without label" do
    represent = Representation.new
    represent.save.should be_true
  end

  it "should create a representation without label and make a label for it" do
    represent = Representation.new
    represent.save!
    represent.label.should_not be_nil
  end

  it "should create a representation and make a label for it even though a blank label is assigned" do
    represent = Representation.new(:label=>"")
    represent.label.should == ""
    represent.save!
    represent.label.should_not be_nil
  end
end

describe "update" do
  before do
    @represent1 = Representation.new(:label=>"first label")
    @represent1.save!
  end
  it "should be able to update a label" do
    represent2 = Representation.find(@represent1.pid)
    represent2.label = "second label"
    represent2.save!
    represent2.label.should == "second label"
  end
end

describe "destroy"  do
  before do
    @represent = Representation.new
    @represent.save!
  end
  it "should be able to delete a representation" do
    count = Representation.count
    @represent.destroy
    Representation.count.should == count - 1
  end
end