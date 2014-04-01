Feature: View DOD eBog meta-data
  As a user
  I want to be able to view correct MODS meta-data for a created DOD eBook

  Background: Logged in
    Given I am signed in with provider "ldap"

    @omniauth_test
    Scenario: Viewing correct MODS metadata for an eBook
      Given I have created a new eBook
      And I have saved eBook
      When I navigate to the landing page for the eBook
      Then I should see the correct MODS metadata for the eBook

