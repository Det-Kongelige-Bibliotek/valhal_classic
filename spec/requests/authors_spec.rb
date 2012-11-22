# encoding: utf-8
require 'spec_helper'

describe "Authors" do

  describe "Create a author" do
    it "should create a author" do

      visit new_author_path
      fill_in "author_forename", with: "Alex"
      fill_in "author_surname", with: "Boesen"

      click_button "Create"
      page.should have_content "forfatter er blevet tilføjet"
      page.should have_content "Alex Boesen"
    end
  end

  describe "Edit a author" do
    before do
      Author.create!(forename: "Al", surname: "Bo")
    end
    it "should edit a author" do
      visit
    end
  end
end
