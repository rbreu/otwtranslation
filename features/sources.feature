Feature: Translation sources
  In order to manage sources
  As a translator
  I want to view the source table

  Scenario: View phrases
    Given someone has visited the hello world page
    And I am a translator

    When I go to the source table
    Then I should see the heading "Source Table"
    And I should see the source action "hello#world"

    When I follow "hello#world"
    Then I should see the heading "Show Source"
    And I should see the source action "hello#world"
    And I should see the source url "hello/world"
    And I should see phrase with current version "yes"
    And I should see the phrase "Hello World!"
