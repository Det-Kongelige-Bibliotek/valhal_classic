# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Representation do
  describe "Create" do
    it "should be possible to create and save a raw representation without arguments" do
      rep = Representation.new
      rep.save.should == true
    end

    it "should be possible to create and save a raw representation with the label as argument" do
      rep = Representation.new(:label=>"LaBeL")
      rep.save.should == true
    end

    it "should be assigned a label when created without the label argument" do
      rep = Representation.new
      rep.save!
      rep.label.should_not be_nil
    end

    it "should store the assigned a label when created with the label argument" do
      rep = Representation.new(:label => "LaBeL")
      rep.save!
      rep.label.should == "LaBeL"
    end

    it "should assign a label if the label has been defined as nil" do
      rep = Representation.new(:label => nil)
      rep.label.should be_nil
      rep.save!
      rep.label.should_not be_nil
    end
  end

  describe "Update" do
    before do
      @rep = Representation.new
      @rep.save!
    end
    it "should be possible to set a new value for the label" do
      @rep.label.should_not be_nil
      @rep.label = "LaBeL"
      @rep.save!
      rep2 = Representation.find(@rep.pid)
      rep2.label.should == "LaBeL"
    end
  end

  describe "Destroy" do
    before do
      @rep = Representation.new
      @rep.save!
    end
    it "should be possible to delete a representation" do
      count = Representation.count
      @rep.destroy
      Representation.count.should == count - 1
    end
  end
  
  describe "Inherited" do
    before do
      class InheritedRepresentation < Representation
      end
    end

    it "should as default get its own class name as label" do
      ir = InheritedRepresentation.new
      ir.save!
      ir.label.should == InheritedRepresentation.name
    end
    
    after do
      InheritedRepresentation.all.each { |ir| ir.destroy }
    end
  end

  after (:all) do
    Representation.all.each { |r| r.destroy }
  end
end
