Feature: Perform CRUD operations on a person
  As a user
  I want to be able to create, read, update and delete a person

  Background: Logged in
    Given I am signed in with provider "ldap"

  @omniauth_test
  Scenario: Creating a person
    Given I have created a new person
    When I have saved the person
    Then I should see the person successfully created

  @omniauth_test
  Scenario: Reading a person
    Given I search for an existing person
    When I click on the search result for a person
    Then I should see the person

  @omniauth_test
  Scenario: Updating a person
    Given I search for an existing person
    And I click on the search result for a person
    And I edit the person with some new metadata
    Then I should see the person successfully updated

  @omniauth_test
  Scenario: Deleting a person
    Given I browse all persons
    When I delete a person
    Then I should see the person removed from the list of persons

