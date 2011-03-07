Feature: Translation home page
  In order to manage translations on the archive
  As a translator
  I want to view the translation home page

  Scenario: View the translation home page
    Given I am a translator
    When I go to the translation home page
    Then I should see "Translation Home"

