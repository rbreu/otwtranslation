Feature: Translation phrases
  In order to have languages
  As a translation admin
  I want to view and manage languages

  Scenario: View languages
    Given I am a translation admin
    And I have the language Deutsch
    When I go to the languages list
    Then I should see "Language List" within "h1"
    And I should see "Deutsch" within "td.name"
    When I follow "Deutsch"
    Then I should see "Show Language" within "h1"
    And I should see "de" within "dd.short"
    And I should see "Deutsch" within "dd.name"
    And I should see "no" within "dd.right_to_left"
    And I should see "yes" within "dd.translation_viewable"

  Scenario: Add a language
    Given I am a translation admin
    When I go to the languages list
    And I follow "Add language"
    Then I should see "Add Language" within "h1"

    When I fill in the following:
      | Short: | de      |
      | Name:  | Deutsch |
    And I uncheck "Right to left?"
    And I check "Translation viewable?"
    And I press "Add language"
    Then I should see "Show Language" within "h1"
    And I should see "de" within "dd.short"
    And I should see "Deutsch" within "dd.name"
    And I should see "no" within "dd.right_to_left"
    And I should see "yes" within "dd.translation_viewable"

    When I go to the languages list
    Then I should see "Language List" within "h1"
    And I should see "Deutsch" within "td.name"





