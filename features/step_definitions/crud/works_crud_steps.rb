# -*- encoding : utf-8 -*-
require 'capybara/rspec'

timestamp = DateTime.now

Given(/^I have created a new work with no meta\-data or files$/) do
  click_link 'New Work'
  fill_in 'Work type', :with => 'DOD eBook'
  fill_in 'Title', :with => 'Instant Apache Solr'
  fill_in 'Subtitle', :with => "Test PDF-#{timestamp}"
  click_on 'Next'
  click_on 'Next'
  click_on 'Next'
end

When(/^I have saved the work$/) do
  click_on 'Done'
end

Then(/^I should see the work successfully created$/) do
  page.should have_content 'Work was successfully created'
end

Given(/^I search for an existing work$/) do
  fill_in 'q', :with => 'Instant Apache Solr'
  click_on 'Search'
end

Then(/^I should see the work$/) do
  page.should have_content 'Instant Apache Solr'
  page.should have_content "Test PDF-#{timestamp}"
end

Given(/^I click on the search result for it$/) do
  click_link "Instant Apache Solr, Test PDF-#{timestamp}"
end

Given(/^I edit the work with some new metadata$/) do
  click_link 'Edit metadata'
  fill_in 'Publisher', :with => 'Manning'
  click_on 'Next'
end

Then(/^I should see the work successfully updated$/) do
  page.should have_content 'Manning'
end

Given(/^I browse all works$/) do
  click_link 'Works'
end

When(/^I delete a work$/) do
  click_link 'Delete'
end

Then(/^I should see the work removed from the list of works$/) do
  page.should_not have_content 'Instant Apache Solr'
end
