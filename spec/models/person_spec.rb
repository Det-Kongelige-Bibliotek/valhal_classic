# -*- encoding : utf-8 -*-
require 'spec_helper'

# TODO: need tests for the variables (besides firstname)
describe Person do
  describe "#create" do
    it "should be created when given a firstname and lastname" do
      person = Person.new
      person.firstname = "The firstname of the person"
      person.lastname = "The lastname of the person"
      person.save.should == true
    end

    it "should be created directly with a firstname and lastname" do
      person = Person.new(firstname:"the firstname", lastname:"the lastname")
      person.save!
    end

    it "should not accept an empty firstname and empty lastname" do
      person = Person.new
      person.save.should == false
    end

    it "should not accept an empty firstname" do
      person = Person.new(lastname:"the lastname")
      person.save.should == false
    end

    it "should not accept an empty lastname" do
      person = Person.new(firstname:"the firstname")
      person.save.should == false
    end

    it "should be created when given a firstname, lastname and person_images" do
      person_image = BasicFile.new
      uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'aoa._foto.jpg', type: 'image/jpeg', tempfile: File.new("#{Rails.root}/spec/fixtures/aoa._foto.jpg"))
      person_image.add_file(uploaded_file)
      person_image.save!
      person_image_representation = PersonImageRepresentation.new
      person_image_representation.save!
      person = Person.new(firstname:"the firstname", lastname:"the lastname")
      person_image_representation.person_image_files << person_image
      person.person_image_representation << person_image_representation

      person.save!
    end
  end

  describe "#update" do
    before do
      @person = Person.new(firstname:"the firstname", lastname:"the lastname")
      person_image = BasicFile.new
      person_image.save!
      uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'aoa._foto.jpg', type: 'image/jpeg', tempfile: File.new("#{Rails.root}/spec/fixtures/aoa._foto.jpg"))
      person_image.add_file(uploaded_file)
      person_image_representation = PersonImageRepresentation.new
      person_image_representation.person_image_files << person_image
      person_image_representation.save!
      @person.person_image_representation << person_image_representation
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

    it "should be possible to update the person_images" do

      person_image_representation = PersonImageRepresentation.new
      person_image_representation.save!

      person_image = BasicFile.new
      uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'rails.png', type: 'image/png', tempfile: File.new("#{Rails.root}/spec/fixtures/rails.png"))
      person_image.add_file(uploaded_file)
      person_image.save!
      person_image_representation.person_image_files << person_image

      @person.person_image_representation << person_image_representation
      @person.save!
      person1 = Person.find(@person.pid)
      person1.person_image_representation.last.person_image_files.last.original_filename.should == "rails.png"
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
      person.save.should == false
    end

    it "should not allow empty string for the firstname on creation" do
      person = Person.new(lastname: "some lastname")
      person.should_not be_valid
      person.save.should == false
    end

    it "should not allow empty string for the lastname on creation" do
      person = Person.new(firstname: "some firstname")
      person.should_not be_valid
      person.save.should == false
    end

    it "should not allow spaces for the firstname on creation" do
      person = Person.new(firstname:" ")
      person.should_not be_valid
      person.save.should == false
    end

    it "should not allow spaces for the lastname on creation" do
      person = Person.new(lastname:" ")
      person.should_not be_valid
      person.save.should == false
    end

    it "should not allow empty string for the first name during update" do
      person = Person.new(firstname:"a name", lastname:"a last name")
      person.save!
      person.firstname = ""
      person.should_not be_valid
      person.save.should == false
    end

    it "should not allow empty string for the last name during update" do
      person = Person.new(firstname:"a name", lastname:"a last name")
      person.save!
      person.lastname = ""
      person.should_not be_valid
      person.save.should == false
    end

    it "should not allow empty string for the first name and last name during update" do
      person = Person.new(firstname:"a name", lastname:"a last name")
      person.save!
      person.firstname = ""
      person.lastname = ""
      person.should_not be_valid
      person.save.should == false
    end

    it "should allow valid entries" do
      person = Person.new(firstname:"a name", lastname:"a lastname")
      person.should be_valid
      person.save.should == true
      person.firstname = "another name"
      person.lastname = "another lastname"
      person.should be_valid
      person.save.should == true
    end

    it "should have the first name as a String" do
      person = Person.new(firstname:"a name")
      person.firstname.should be_kind_of String
    end

    it "should have the last name as a String" do
      person = Person.new(lastname:"a name")
      person.lastname.should be_kind_of String
    end
  end

  describe "#delete" do
    before do
      @person = Person.new(firstname:"the name", lastname:"the lastname")
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
      person = Person.new(firstname:"the name", lastname:"the lastname")
      person.save!
      person.uuid.should_not be_nil
    end
  end

  after do
    Person.all.each { |p| p.delete }
  end
end
