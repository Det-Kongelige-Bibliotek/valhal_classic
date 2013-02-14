# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Person do

  # tests for the relationship between the Person and the PersonTeiRepresentation
  describe " - PersonTeiRepresentation relationship" do
    before(:each) do
      @person = Person.create(:firstname=>"some name", :lastname=>"some lastname")
      @person.save
      @tei = PersonTeiRepresentation.new
      @tei.person = @person
      @tei.save!
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
    PersonTeiRepresentation.all.each { |ptr| ptr.delete }
  end
end
