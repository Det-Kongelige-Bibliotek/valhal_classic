# -*- encoding : utf-8 -*-
require 'capybara/rspec'

Given(/^I am signed in with provider "(.*?)"$/) do |provider|
  visit new_user_session_path
  fill_in 'username', :with => 'sifd-ldap-read'
  fill_in 'password', :with => '25};mMnsjydEB./>1pX[O~3NCx9JDV'
  click_button 'Login'
  page.should have_content 'Logged in as Test User!'
end

Given(/^I have created a new work with a PDF file associated with it$/) do
  click_link 'New Work'
  fill_in 'Work type', :with => 'PDF'
  fill_in 'Title', :with => "Test PDF-#{DateTime.now}"
  click_button 'Create and continue'
  click_on 'Next'
  click_on 'Next'
  attach_file 'fileupload', './spec/fixtures/Instant_Apache_Solr.pdf'
end

Given(/^skipped file characterisation$/) do
  check 'skip_file_characterisation'
end

Given(/^I have saved it$/) do
  click_on 'Update'
  page.should have_content 'Type: PDF'
end


When(/^I navigate to the basic file datastreams for that work$/) do
  click_link('SingleFileRepresentation', exact: false)
  click_link 'Instant_Apache_Solr.pdf'
end

Then(/^I should see some FITS file metadata for the PDF file$/) do
  page.should have_content 'fitsMetadata1'
end

Then(/^I should not see any FITS file metadata for the PDF file$/) do
  page.should_not have_content 'fitsMetadata1'
end
