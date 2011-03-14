Feature: Translation phrases
  In order to manage phrases
  As a translator
  I want to view the phrases list and single phrases

  Scenario: View phrases
    Given I'm on revision "0.8"
    And someone has visited the hello world page
    And I am a translator
    When I go to the phrases list
    Then I should see "Phrases List" within "h1"
    And I should see "Hello World!" within "td.phrase"
    When I follow "Hello World!"
    Then I should see "Show Phrase" within "h1"
    And I should see "Hello World!" within "dd.label"
    And I should see "hello/world" within "dd.source"
    And I should see "hello#world" within "dd.source"
    And I should see "0.8" within "dd.version"


