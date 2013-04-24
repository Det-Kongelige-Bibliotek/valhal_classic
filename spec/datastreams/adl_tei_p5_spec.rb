# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Datastreams::AdlTeiP5 do

  subject do
    @file = File.open(File.join(File.dirname(__FILE__), '..', 'fixtures', "aarrebo_tei_p5_sample.xml"))
    @document = Datastreams::AdlTeiP5.from_xml(@file, nil)
  end

  it "should have one person" do
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
  end

  it "should have multiple event descriptions" do

    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.desc.length.should == 9
    descriptions = subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.desc

    descriptions.should be_kind_of Array
  end

  it "should have an event with a various attributes" do
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.type[0].should == "birth"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.when[0].should == "1587"

    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.type[1].should == "ordination"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.when[1].should == "1608"

    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.type[2].should == "promotion"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.when[2].should == "1610"

    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.type[3].should == "promotion"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.when[3].should == "1618"

    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.type[4].should == "demotion"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.when[4].should == "1622"

    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.type[5].should == "publication"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.when[5].should == "1623"

    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.type[6].should == "appointment"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.when[6].should == "1626"

    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.type[7].should == "work"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.from[0].should == "1631"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.to[0].should == "1637"

    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.type[8].should == "death"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.when[7].should == "1637"

  end

  it "should have events with descriptions" do
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.desc[0] == "Født i Ærøskøbing"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.desc[1] == "Præst i København"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.desc[2] == "Magister"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.desc[3] == "Biskop over Trondhjems stift"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.desc[4] == "Fradømt sit embede"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.desc[5] == "K. Davids Psalter, revideret 1627"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.desc[6] == "Sognepræst i Vordingborg"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.desc[7] == "Hovedværket Hexaëmeron, udgivet posthumt 1661"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.event.desc[8] == "Død i Vordingborg"
  end

  it "should have a floruit with a period description and from and to dates" do
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.floruit.period == "Renæssance"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.floruit.from == "1535"
    subject.TEI.teiHeader.profileDesc.particDesc.listPerson.person.floruit.to == "1640"
  end
end