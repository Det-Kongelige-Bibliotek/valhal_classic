# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Datastreams::MyAdlTeiP5Datastream do

  subject do
    @file = File.open(File.join(File.dirname(__FILE__), '..', 'fixtures', "aarrebo_tei_p5_sample.xml"))
    @document = Datastreams::MyAdlTeiP5Datastream.from_xml(@file, nil)
  end

  it "should have one person" do
    puts subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.length
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.length.should == 1
  end

  it "should have a surname" do
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.persName.surname.should == ["Arrebo"]
  end

  it "should have a forename" do
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.persName.forename.length.should == 2
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.persName.forename.should == ["Christensen", "Anders"]
  end

  it "should have a death date" do
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.death.date.should == ["1637"]
  end

  it "should have multiple events" do
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.length.should == 9

    events = subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event
    events.should be_kind_of Array
    events.each {|x| print x, " -- "}
  end
end