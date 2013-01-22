# encoding: utf-8
require 'spec_helper'
#TODO update the request spec show it reflex how the page works now
describe "PersonTeiRepresentations" do
  describe "Create a person_tei_representation" do
    it "should create a person_tei_representation" do
      pending "needs to updated"

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
      pending "needs to updated"
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
