Feature: View file characterisation meta-data
  After creating a new work
  As a user
  I want to be able to view any file characterisation metadata in the datastreams section

  Background: Logged in
    Given I am signed in with provider "ldap"

    @omniauth_test
    Scenario: Successful viewing of FITS file characterisation metadata
      Given I have created a new work with a PDF file associated with it
      And I have saved it
      When I navigate to the basic file datastreams for that work
      Then I should see some FITS file metadata for the PDF file

    @omniauth_test
    Scenario: Successful skipping of generation of FITS file characterisation metadata
      Given I have created a new work with a PDF file associated with it
      And skipped file characterisation
      And I have saved it
      When I navigate to the basic file datastreams for that work
      Then I should not see any FITS file metadata for the PDF file