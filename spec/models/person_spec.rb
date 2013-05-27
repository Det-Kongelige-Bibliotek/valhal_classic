# -*- encoding : utf-8 -*-
require 'spec_helper'

# TODO: need tests for the variables (besides firstname)
describe Person do
  subject { Person.new(firstname: "Test #{Time.now.nsec.to_s}", lastname: "last_test") }
  it_behaves_like "a person with manifestations"
  it_behaves_like "a person with concerns"

  describe "#create" do

    it "should be created when given a firstname and lastname" do
      person = Person.new
      person.firstname = "The firstname of the person"
      person.lastname = "The lastname of the person"
      person.date_of_birth = Time.now.nsec.to_s
      person.save.should be_true
    end

    it "should be created directly with a firstname and lastname" do
      person = Person.new(firstname: "the firstname", lastname: "the lastname", :date_of_birth => Time.now.nsec.to_s)
      person.save!
    end

    it "should not accept an empty firstname and empty lastname" do
      person = Person.new
      person.save.should be_false
    end

    it "should not accept an empty firstname" do
      person = Person.new(lastname: "the lastname")
      person.save.should be_false
    end

    it "should not accept an empty lastname" do
      person = Person.new(firstname: "the firstname")
      person.save.should be_false
    end
  end

  describe "#update" do
    before do
      @person = Person.new(firstname: "the firstname", lastname: "the lastname", :date_of_birth => Time.now.nsec.to_s)
      @person.save!
    end

    it "should be possible to update the firstname" do
      @person.firstname = "another first name"
      @person.save!
      person1 = Person.find(@person.pid)
      person1.firstname.should == "another first name"
    end

    it "should be possible to update the lastname" do
      @person.lastname = "another last name"
      @person.save!
      person1 = Person.find(@person.pid)
      person1.lastname.should == "another last name"
    end

    it "should be possible to update the person date of birth" do
      @person.date_of_birth = "22nd February 2013"
      @person.save!
      person1 = Person.find(@person.pid)
      person1.date_of_birth.should == "22nd February 2013"
    end

    it "should be possible to update the person date of death" do
      @person.date_of_death = "22nd November 2083"
      @person.save!
      person1 = Person.find(@person.pid)
      person1.date_of_death.should == "22nd November 2083"
    end
  end

  describe "#validate" do
    it "should not allow empty string for the firstname and lastname on creation" do
      person = Person.new
      person.should_not be_valid
      person.save.should be_false
    end

    it "should not allow empty string for the firstname on creation" do
      person = Person.new(lastname: "some lastname")
      person.should_not be_valid
      person.save.should be_false
    end

    it "should not allow empty string for the lastname on creation" do
      person = Person.new(firstname: "some firstname")
      person.should_not be_valid
      person.save.should be_false
    end

    it "should not allow spaces for the firstname on creation" do
      person = Person.new(firstname: " ")
      person.should_not be_valid
      person.save.should be_false
    end

    it "should not allow spaces for the lastname on creation" do
      person = Person.new(lastname: " ")
      person.should_not be_valid
      person.save.should be_false
    end

    it "should not allow empty string for the first name during update" do
      person = Person.new(firstname: "a name", lastname: "a last name", :date_of_birth => Time.now.nsec.to_s)
      person.save!
      person.firstname = ""
      person.should_not be_valid
      person.save.should be_false
    end

    it "should not allow empty string for the last name during update" do
      person = Person.new(firstname: "a name", lastname: "a last name", :date_of_birth => Time.now.nsec.to_s)
      person.save!
      person.lastname = ""
      person.should_not be_valid
      person.save.should be_false
    end

    it "should not allow empty string for the first name and last name during update" do
      person = Person.new(firstname: "a name", lastname: "a last name", :date_of_birth => Time.now.nsec.to_s)
      person.save!
      person.firstname = ""
      person.lastname = ""
      person.should_not be_valid
      person.save.should be_false
    end

    it "should allow valid entries" do
      person = Person.new(firstname: "a name", lastname: "a lastname", :date_of_birth => Time.now.nsec.to_s)
      person.should be_valid
      person.save.should be_true
      person.firstname = "another name"
      person.lastname = "another lastname"
      person.should be_valid
      person.save.should be_true
    end

    it "should have the first name as a String" do
      person = Person.new(firstname: "a name")
      person.firstname.should be_kind_of String
    end

    it "should have the last name as a String" do
      person = Person.new(lastname: "a name")
      person.lastname.should be_kind_of String
    end
  end

  describe "#delete" do
    before do
      @person = Person.new(firstname: "the name", lastname: "the lastname", :date_of_birth => Time.now.nsec.to_s)
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

  describe "validation" do
    it "should be valid for a unique person without dates both before and after save (e.g. should not invalidate it self)" do
      person = Person.new(firstname: "Søren", lastname: "Kierkegaard")
      person.valid?.should be_true
      person.save.should be_true
      person.valid?.should be_true
    end

    it "should allow people with different names and no dates" do
      person1 = Person.new(firstname: "Søren", lastname: "Kierkegaard");
      person1.valid?.should be_true
      person1.save!
      person2 = Person.new(firstname: "Hans Christian", lastname: "Andersen");
      person2.valid?.should be_true
      person2.save.should be_true
    end

    it "should not allow people with identical names and no dates" do
      person1 = Person.new(firstname: "Søren", lastname: "Kierkegaard");
      person1.valid?.should be_true
      person1.save!
      person2 = Person.new(firstname: "Søren", lastname: "Kierkegaard");
      person2.valid?.should be_false
      expect { person2.save! }.to raise_error(ActiveFedora::RecordInvalid, /Person cannot be duplicated/)
    end

    it "should allow people with identical names but different date values" do
      person1 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "5. maj 1813", date_of_death: "11. november 1855")
      person1.valid?.should be_true
      person1.save!
      person2 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "05/05/13", date_of_death: "11/11/55");
      person2.valid?.should be_true
      person2.save.should be_true
    end

    it "should not allow people with identical names and identical date values" do
      person1 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "5. maj 1813", date_of_death: "11. november 1855")
      person1.valid?.should be_true
      person1.save!
      person2 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "5. maj 1813", date_of_death: "11. november 1855")
      person2.valid?.should be_false
      expect { person2.save! }.to raise_error(ActiveFedora::RecordInvalid, /Person cannot be duplicated/)
    end

    it "should allow people with identical names, identical birthdays, but different death dates" do
      person1 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "5. maj 1813", date_of_death: "11. november 1855")
      person1.valid?.should be_true
      person1.save!
      person2 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "5. maj 1813", date_of_death: "11/11/55")
      person2.valid?.should be_true
      person2.save.should be_true
    end

    it "should allow people with identical names, identical death dates, but different birthdays" do
      person1 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "5. maj 1813", date_of_death: "11. november 1855")
      person1.valid?.should be_true
      person1.save!
      person2 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "05/05/13", date_of_death: "11. november 1855")
      person2.valid?.should be_true
      person2.save.should be_true
    end

    it "should allow people with identical names, but different birthdays and no death dates" do
      person1 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "5. maj 1813")
      person1.valid?.should be_true
      person1.save!
      person2 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "05/05/13")
      person2.valid?.should be_true
      person2.save.should be_true
    end

    it "should not allow people with identical names, and same birthdays and no death dates" do
      person1 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "5. maj 1813")
      person1.valid?.should be_true
      person1.save!
      person2 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "5. maj 1813")
      person2.valid?.should be_false
      expect { person2.save! }.to raise_error(ActiveFedora::RecordInvalid, /Person cannot be duplicated/)
    end

    it "should allow people with identical names, but different death dates and no birthdays" do
      person1 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_death: "11. november 1855")
      person1.valid?.should be_true
      person1.save!
      person2 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_death: "11/11/55")
      person2.valid?.should be_true
      person2.save.should be_true
    end

    it "should not allow people with identical names, and same death dates and no birthdays" do
      person1 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_death: "11. november 1855")
      person1.valid?.should be_true
      person1.save!
      person2 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_death: "11. november 1855")
      person2.valid?.should be_false
      expect { person2.save! }.to raise_error(ActiveFedora::RecordInvalid, /Person cannot be duplicated/)
    end

    it "should allow people with different lastnames, but identical birth dates and death dates" do
      person1 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "5. maj 1813", date_of_death: "11. november 1855")
      person1.valid?.should be_true
      person1.save!
      person2 = Person.new(firstname: "Søren", lastname: "K", date_of_birth: "5. maj 1813", date_of_death: "11. november 1855")
      person2.valid?.should be_true
      person2.save.should be_true
    end

    it "should allow people with different firstnames, but identical birth dates and death dates" do
      person1 = Person.new(firstname: "Søren", lastname: "Kierkegaard", date_of_birth: "5. maj 1813", date_of_death: "11. november 1855")
      person1.valid?.should be_true
      person1.save!
      person2 = Person.new(firstname: "Søren Aabye", lastname: "Kierkegaard", date_of_birth: "5. maj 1813", date_of_death: "11. november 1855")
      person2.valid?.should be_true
      person2.save.should be_true
    end
  end

  describe " as an IntellectualEntity" do
    it "should have an UUID" do
      person = Person.new(firstname: "the name", lastname: "the lastname", :date_of_birth => Time.now.nsec.to_s)
      person.save!
      person.uuid.should_not be_nil
    end
  end

  after :each do
    Person.all.each { |p| p.delete }
  end
end
