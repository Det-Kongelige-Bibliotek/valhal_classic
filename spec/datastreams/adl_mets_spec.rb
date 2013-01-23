# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Datastreams::AdlMets do
  subject do
    @file = File.open(File.join(File.dirname(__FILE__), '..', 'fixtures', "aarebo_mets_structmap_sample.xml"))
    @document = Datastreams::AdlMets.from_xml(@file, nil)
  end

  it "should have a structMap element" do
    subject.mets.structMap.length.should == 1
  end

  it "structMap element should have a TYPE attribute with a value of physical" do
    subject.mets.structMap.type[0].should == "physical"
  end

  it "should have a div element underneath the structMap element" do
    subject.mets.structMap.div.length.should == 1
  end

  it "div element underneath the structMap element should have an ORDER attribute with a value of 1" do
    subject.mets.structMap.div.order[0].should == "1"
  end

  it "should have another div element underneath the first div element" do
    subject.mets.structMap.div.div.length.should == 6
  end

  it "should have another div element underneath the first div element with a ORDER attribute with a value of 1" do
    subject.mets.structMap.div.div.order[0].should == "1"
  end

  it "should have 24 fptr elements" do
    subject.mets.structMap.div.div.fptr.length.should == 24
  end

end