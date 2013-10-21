# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Books" do
  before(:each) do
    pending "Does not work!"
    visit  "http://localhost:3000/users/sign_in?locale=en" #new_user_session_url
    fill_in 'Username', :with => CONFIG[:test][:user]
    fill_in 'Password', :with => CONFIG[:test][:password]
    click_button 'Login'
    #login_admin
  end

  describe "Create Book" do
    before (:each) do
      visit "http://localhost:3000/people/new?locale=en"    #new_person_url
      fill_in "person_firstname", :with => "FNPerson"
      fill_in "person_lastname", :with => "LNPerson"
      click_button "Create"
    end

    it "Create book" do
      pending 'Failing unit-test'
      visit "http://localhost:3000/books/new?locale=en" #new_book_url
      fill_in "Title", :with => "test book"
      click_button "Create"
      page.should have_content("Book was successfully created.")
      page.should have_content("test book")
    end

    it "Create book with Author" do
      pending 'Failing unit-test'
      visit "http://localhost:3000/books/new?locale=en"   #new_book_url
      fill_in "Title", :with => "test book"
      select  "LNPerson, FNPerson", :from => "person_id"
      click_button "Create"
      page.should have_content("Book was successfully created.")
      page.should have_content("FNPerson LNPerson")
    end

  end

  after(:each) do
    Book.all.each { |book| book.delete }
    Person.all.each { |person| person.delete }
  end
end
