# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Books" do
  before(:each) do
    visit 'http://localhost:3000/users/sign_in?locale=en'
    fill_in 'Username', :with => CONFIG[:test][:user]
    fill_in 'Password', :with => CONFIG[:test][:password]
    click_button 'Login'
    #login_admin
  end

  describe "Create Book" do
    before (:each) do
      visit "http://localhost:3000/people/new?locale=en"
      fill_in "person_firstname", :with => "FNPerson"
      fill_in "person_lastname", :with => "LNPerson"
      click_button "Create"
    end

    it "Create book" do
      visit "http://localhost:3000/books/new?locale=en"
      fill_in "Title", :with => "test book"
      click_button "Create"
      page.should have_content("Book was successfully created.")
      page.should have_content("test book")
    end

    it "Create book with Author" do
      visit "http://localhost:3000/books/new?locale=en"
      fill_in "Title", :with => "test book"
      select  "LNPerson, FNPerson", :from => "person_id"
      click_button "Create"
      page.should have_content("Book was successfully created.")
      page.should have_content("FNPerson LNPerson")
    end

    it "Create book with TEI file" do
      visit "http://localhost:3000/books/new?locale=en"
      fill_in "Title", :with => "test book"
      select  "LNPerson, FNPerson", :from => "person_id"
      click_button "Create"
      page.should have_content("Book was successfully created.")
      page.should have_content("FNPerson LNPerson")
    end

  end

  after(:all) do
    Book.all.each { |book| book.delete }
  end
end
