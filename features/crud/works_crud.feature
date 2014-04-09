Feature: Perform CRUD operations on a work
  As a user
  I want to be able to create, read, update and delete a work

  Background: Logged in
    Given I am signed in with provider "ldap"

  @omniauth_test
  Scenario: Creating a work
    Given I have created a new work with no meta-data or files
    When I have saved the work
    Then I should see the work successfully created

  @omniauth_test
  Scenario: Reading a work
    Given I search for an existing work
    When I click on the search result for it
    Then I should see the work

  @omniauth_test
  Scenario: Updating a work
    Given I search for an existing work
    And I click on the search result for it
    And I edit the work with some new metadata
    When I have saved the work
    Then I should see the work successfully updated

  @omniauth_test
  Scenario: Deleting a work
    Given I browse all works
    When I delete a work
    Then I should see the work removed from the list of works

