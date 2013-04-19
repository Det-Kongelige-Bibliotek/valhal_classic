# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Person do

  # tests for the relationship between the Person and the PersonTeiRepresentation
  describe " - PersonTeiRepresentation relationship" do
    let(:representation) { DefaultRepresentation }
    before(:each) do
      @person = Person.new(:firstname=>"some name", :lastname=>"some lastname")
      @tei = representation.new
      @person.tei << @tei
      @person.save!
    end

    it "should be defined in the Person entity" do
      @person.tei.should_not be_nil
      @person.tei.should_not be_empty
      @person.tei.length.should == 1
      @person.tei.first.should == @tei
    end

    it "should be defined in the PersonTeiRepresentation entity" do
      @tei.person.should_not be_nil
      @tei.person.should == @person
      @tei.person.tei.first.should == @tei
    end
  end

  after do
    Person.all.each { |person| person.delete }
    representation.all.each { |ptr| ptr.delete }
  end
end
