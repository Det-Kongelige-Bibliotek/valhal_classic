# -*- encoding : utf-8 -*-
require 'spec_helper'

# TODO: need tests for the variables (besides firstname)
describe Person do
  describe "#create" do
    it "should be created when given a name" do
      person = Person.new
      person.firstname = "The name of the person"
      person.save.should == true
    end

    it "should be created directly with a name" do
      person = Person.new(firstname:"the name")
      person.save!
    end

    it "should not accept an empty name" do
      person = Person.new
      person.save.should == false
    end
  end

  describe "#update" do
    before do
      @person = Person.new(firstname:"the name")
      @person.save!
    end

    it "should be possible to update the name" do
      @person.firstname = "another name"
      @person.save!
      person1 = Person.find(@person.pid)
      person1.firstname.should == "another name"
    end
  end

  describe "#validate" do
    it "should not allow empty string for the name on creation" do
      person = Person.new
      person.should_not be_valid
      person.save.should == false
    end

    it "should not allow spaces for the name on creation" do
      person = Person.new(firstname:" ")
      person.should_not be_valid
      person.save.should == false
    end

    it "should not allow empty string for the name during update" do
      person = Person.new(firstname:"a name")
      person.save!
      person.firstname = ""
      person.should_not be_valid
      person.save.should == false
    end

    it "should allow valid entries" do
      person = Person.new(firstname:"a name")
      person.should be_valid
      person.save.should == true
      person.firstname = "another name"
      person.should be_valid
      person.save.should == true
    end

    it "should have the name as a String" do
      person = Person.new(firstname:"a name")
      person.firstname.should be_kind_of String
    end
  end

  describe "#delete" do
    before do
      @person = Person.new(firstname:"the name")
      @person.save!
    end

    it "should be possible to locate from the pid" do
      person2 = Person.find(@person.pid)
      person2.should_not be_nil
      person2.should == @person
    end

    it "should be possible to delete" do
      count = Person.count
      @person.destroy
      Person.count.should == count-1
    end
  end

  describe " as an IntellectualEntity" do
    it "should have an UUID" do
      person = Person.new(firstname:"the name")
      person.save!
      person.uuid.should_not be_nil
    end
  end

  after do
    Person.all.each { |p| p.delete }
  end
end
