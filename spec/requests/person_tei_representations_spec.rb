# encoding: utf-8
require 'spec_helper'

describe "PersonTeiRepresentations" do
  describe "GET /person_tei_representations" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get person_tei_representations_path
      response.status.should be(200)
    end
  end

  describe "Create a person_tei_representation" do
    it "should create a person_tei_representation" do

      visit new_person_tei_representation_path
      fill_in "person_tei_representation_forename", with: "Alex"
      fill_in "person_tei_representation_surname", with: "Boesen"
      fill_in "person_tei_representation_date_of_birth", with: "1988"
      fill_in "person_tei_representation_date_of_death", with: "2012"

      click_button "Create"
      page.should have_content "TEI repræsentationen af personen er blevet tilføjet"
      page.should have_content "Alex Boesen"
    end
  end

  describe "Edit a person_tei_representation" do
    before do
      PersonTeiRepresentation.all.each { |a| a.delete }
      @person_tei_representation = PersonTeiRepresentation.create(forename: "Al", surname: "Boesen", date_of_birth: "1988", date_of_death: "2012")
    end
    it "should edit a person_tei_representation" do
      visit person_tei_representations_path
      page.should have_content "Al Boesen"
      click_link "Ændre"
      fill_in "person_tei_representation_forename", with: "Alex"
      click_button "Update"
      page.should have_content "Alex Boesen"
      page.should have_content "TEI repræsentationen af personen er blevet ændret"
    end
  end
end
