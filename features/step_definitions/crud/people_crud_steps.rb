# -*- encoding : utf-8 -*-
require 'capybara/rspec'

Given(/^I have created a new person$/) do
  click_link 'New Person'
  fill_in 'person_firstname', :with => 'Tycho'
  fill_in 'person_lastname', :with => 'Brahe'
end

When(/^I have saved the person$/) do
  click_on 'Done'
end

Then(/^I should see the person successfully created$/) do
  page.should have_content 'Person was successfully created'
end

Given(/^I search for an existing person$/) do
  fill_in 'q', :with => 'Tycho Brahe'
  click_on 'Search'
end

When(/^I click on the search result for a person$/) do
  within('div#documents') do
    click_link 'Brahe, Tycho'
  end
end

Then(/^I should see the person$/) do
  page.should have_content 'Tycho Brahe'
end

Given(/^I edit the person with some new metadata$/) do
  click_on 'Edit'
  fill_in 'person_date_of_birth', :with => '14 December 1546'
  fill_in 'person_date_of_death', :with => '24 October 1601'
  click_on 'Update'
end

Then(/^I should see the person successfully updated$/) do
  page.should have_content 'Person was successfully updated'
  page.should have_content '14 December 1546'
  page.should have_content '24 October 1601'
end

Given(/^I browse all persons$/) do
  click_on 'People'
end

When(/^I delete a person$/) do
  click_link 'Delete'
end

Then(/^I should see the person removed from the list of persons$/) do
  page.should_not have_content 'Tycho Brahe'
end
