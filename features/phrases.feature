Feature: Translation phrases
  In order to manage phrases
  As a translator
  I want to view the phrases list and single phrases

  Scenario: View phrases
    Given someone has visited the hello world page
    And I am a translator
    When I go to the phrases list
    Then I should see "Phrases List" within "h1"
    And I should see "Hello World!" within "table"
    When I follow "Hello World!"
    Then I should see "Show Phrase" within "h1"
    And I should see "Hello World!"
    And I should see "hello/world"
    And I should see "hello#world"


