Feature: Translation phrases
  In order to have languages
  As a translation admin
  I want to view and manage languages

  Scenario: View phrases
    Given I am a translation admin
    And I have the language Deutsch
    When I go to the languages list
    Then I should see "Languages List" within "h1"
    And I should see "Deutsch" within "td.name"
    When I follow "Deutsch"
    Then I should see "Show Language" within "h1"
    And I should see "de" within "dd.short"
    And I should see "Deutsch" within "dd.name"
    And I should see "No" within "dd.right_to_left"
    And I should see "No" within "translation_viewable"




