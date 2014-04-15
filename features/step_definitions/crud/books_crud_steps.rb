# -*- encoding : utf-8 -*-
require 'capybara/rspec'

Given(/^I have created a new book$/) do
  click_link 'New Book'
  fill_in 'Title', :with => 'Berlin Noir'
  fill_in 'Subtitle', :with => 'A Bernie Gunther Novel'
  click_on 'Next'
  click_on 'Next'
  click_on 'Next'
end

When(/^I have saved the book$/) do
  click_on 'Done'
end

Then(/^I should see the book successfully created$/) do
  page.should have_content 'Book was successfully created'
end

Given(/^I search for an existing book$/) do
  fill_in 'q', :with => 'Berlin Noir'
  click_on 'Search'
end

When(/^I click on the search result for a book$/) do
  within('div#documents') do
    click_link 'Berlin Noir, A Bernie Gunther Novel'
  end
end

Then(/^I should see the book$/) do
  page.should have_content 'Berlin Noir'
  page.should have_content 'A Bernie Gunther Novel'
end

Given(/^I edit the book with some new metadata$/) do
  click_link 'Edit'
  fill_in 'Publisher', :with => 'Penguin'
  click_on 'Next'
  click_on 'Done'
end

Then(/^I should see the book successfully updated$/) do
  page.should have_content 'Book was successfully created.'
  page.should have_content 'Penguin'
end

Given(/^I browse all books$/) do
  click_link 'Books'
end

When(/^I delete a book$/) do
  click_link 'Delete'
end

Then(/^I should see the book removed from the list of books$/) do
  page.should_not have_content 'Berlin Noir'
end
