require 'spec_helper'

describe "Works" do
  before(:each) do
    visit 'http://localhost:3000/users/sign_in?locale=en'
    fill_in 'Username', :with => CONFIG[:test][:user]
    fill_in 'Password', :with => CONFIG[:test][:password]
    click_button 'Login'
  end

  describe "Create works" do
    before (:each) do
      #visit new_person_path
      visit "http://localhost:3000/people/new?locale=en"
      fill_in "person_firstname", :with => "FNPerson"
      fill_in "person_lastname", :with => "LNPerson"
      click_button "Create"
      visit "http://localhost:3000/books/new?locale=en"
      fill_in "Title", :with => "test book"
      click_button "Create"
    end
    it "Create works" do
      visit "http://localhost:3000/works/new?locale=en"
      fill_in  "work_title", :with => "my work"

    end
  end

  after(:all) do
    Book.all.each { |book| book.delete }
    Person.all.each { |person| person.delete }
    Work.all.each { |work| work.delete }
  end
end
