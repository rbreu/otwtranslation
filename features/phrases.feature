Feature: Translation phrases
  In order to manage phrases
  As a translator
  I want to view the phrases list and single phrases

  Scenario: View phrases
    Given I'm on revision "0.8"
    And someone has visited the hello world page
    And I am a translator

    When I go to the phrases list
    Then I should see the heading "Phrases List"
    And I should see the phrase "Hello World!"

    When I follow "Hello World!"
    Then I should see the heading "Show Phrase"
    And I should see the phrase "Hello World!"
    And I should see the phrase source "hello/world"
    And I should see the phrase source "hello#world"
    And I should see the phrase version "0.8"
    And I should see "There are no translations for the selected language."


