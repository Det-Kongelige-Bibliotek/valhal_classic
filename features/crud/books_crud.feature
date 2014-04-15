Feature: Perform CRUD operations on a book
  As a user
  I want to be able to create, read, update and delete a book

  Background: Logged in
    Given I am signed in with provider "ldap"

  @omniauth_test
  Scenario: Creating a book
    Given I have created a new book
    When I have saved the book
    Then I should see the book successfully created

  @omniauth_test
  Scenario: Reading a book
    Given I search for an existing book
    When I click on the search result for a book
    Then I should see the book

  @omniauth_test
  Scenario: Updating a book
    Given I search for an existing book
    And I click on the search result for a book
    And I edit the book with some new metadata
    Then I should see the book successfully updated

  @omniauth_test
  Scenario: Deleting a book
    Given I browse all books
    When I delete a book
    Then I should see the book removed from the list of books

