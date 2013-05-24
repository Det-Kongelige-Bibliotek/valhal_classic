# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Books" do
  before(:each) do
    visit new_user_session_url
    fill_in 'Username', :with => CONFIG[:test][:user]
    fill_in 'Password', :with => CONFIG[:test][:password]
    click_button 'Login'
    #login_admin
  end

  describe "Create Book" do
    before (:each) do
      visit new_person_url
      fill_in "person_firstname", :with => "FNPerson"
      fill_in "person_lastname", :with => "LNPerson"
      click_button "Create"
    end

    it "Create book" do
      visit new_book_url
      fill_in "Title", :with => "test book"
      click_button "Create"
      page.should have_content("Book was successfully created.")
      page.should have_content("test book")
    end

    it "Create book with Author" do
      visit new_book_url
      fill_in "Title", :with => "test book"
      select  "LNPerson, FNPerson", :from => "person_id"
      click_button "Create"
      page.should have_content("Book was successfully created.")
      page.should have_content("FNPerson LNPerson")
    end

  end

  after(:all) do
    Book.all.each { |book| book.delete }
    Person.all.each { |person| person.delete }
  end
end
