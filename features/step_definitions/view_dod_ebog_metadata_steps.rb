# -*- encoding : utf-8 -*-
require 'capybara/rspec'

timestamp = DateTime.now

Given(/^I have created a new eBook$/) do
  click_link 'New Work'
  fill_in 'Work type', :with => 'DOD eBook'
  fill_in 'Title', :with => 'Instant Apache Solr'
  fill_in 'Subtitle', :with => "Test PDF-#{timestamp}"
  click_on 'Next'
  click_on 'Next'
  click_on 'Next'
  attach_file 'fileupload', './spec/fixtures/testdod.pdf'
end

Given(/^I have saved eBook$/) do
  click_on 'Done'
  page.should have_content 'Type: DOD eBook'
end

When(/^I navigate to the landing page for the eBook$/) do
  visit root_path
  click_link('DOD eBook', exact: false)
  print page.html
  click_link("Instant Apache Solr, Test PDF-#{timestamp}", exact: false)
end

Then(/^I should see the correct MODS metadata for the eBook$/) do
  print page.html
end
