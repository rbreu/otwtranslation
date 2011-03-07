Feature: Translation phrases
  In order to manage phrases
  As a translator
  I want to view the phrases list

  Scenario: View the phrases list
    Given I am a translator
    When I go to the phrases list
    Then I should see "Phrases"

