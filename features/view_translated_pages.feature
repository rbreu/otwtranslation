Feature: View translated pages
  In order to view pages in different languages
  As a user
  I want to select a language
  And I want to see pages in that language

  Scenario: View the home page in the default language
    Given I am a user
    When I go to the homepage
    Then I should see "Welcome to the translation engine!"


