Feature: Translation phrases
  In order to manage phrases
  As a translator
  I want to view the phrases list and single phrases

  Scenario: View the phrases list
    Given I am a translator
    When I go to the phrases list
    Then I should see "Phrases List" within "h1"

  Scenario: View a phrase
    Given I am a translator
    And given I have the phrase "Hello World!"
    When I go to the phrases list
    Then I should see "Hello World!" within "td"
    When I follow "Hello World!"
    Then I should see "Show Phrase" within "h1"
    And I should see "Hello World!" within "p"

