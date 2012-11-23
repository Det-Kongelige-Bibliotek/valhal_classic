# encoding: utf-8
require 'spec_helper'

describe "Authors" do

  describe "Create a author" do
    it "should create a author" do

      visit new_author_path
      fill_in "author_forename", with: "Alex"
      fill_in "author_surname", with: "Boesen"
      fill_in "author_date_of_birth", with: "1988"
      fill_in "author_date_of_death", with: "2012"

      click_button "Create"
      page.should have_content "forfatter er blevet tilføjet"
      page.should have_content "Alex Boesen"
    end
  end

  describe "Edit a author" do
    before do
      Author.all.each { |a| a.delete }
      @author = Author.create(forename: "Al", surname: "Boesen", date_of_birth: "1988", date_of_death: "2012")
    end
    it "should edit a author" do
      visit authors_path
      page.should have_content "Al Boesen"
      click_link "Ændre"
      fill_in "author_forename", with: "Alex"
      click_button "Update"
      page.should have_content "Alex Boesen"
      page.should have_content "Forfatter er blevet ændret"
    end
  end




end
