# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Person" do
  before(:each) do
    visit "http://localhost:3000/users/sign_in?locale=en"
    fill_in 'Username', :with => CONFIG[:test][:user]
    fill_in 'Password', :with => CONFIG[:test][:password]
    click_button 'Login'
  end

  describe "Create person" do
    it "Create Person" do
      visit "http://localhost:3000/people/new?locale=en"   #new_person_url
      fill_in "person_firstname", :with => "FNPerson"
      fill_in "person_lastname", :with => "LNPerson"
      click_button "Create"
      page.should have_content("Person was successfully created.")
      page.should have_content("FNPerson LNPerson")
    end

    it "Person exist in book" do
      visit "http://localhost:3000/people/new?locale=en"   #new_person_url
      fill_in "person_firstname", :with => "FNPerson"
      fill_in "person_lastname", :with => "LNPerson"
      click_button "Create"
      visit "http://localhost:3000/books/new?locale=en"       #new_book_url
      page.should have_content("LNPerson, FNPerson")
    end

    it "Person exist in work" do
      visit "http://localhost:3000/works/new?locale=en"
      page.should have_content("LNPerson FNPerson")
    end
  end

  after(:all) do
    Person.all.each { |person| person.delete }
  end
end
