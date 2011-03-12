Feature: Translation sources
  In order to manage sources
  As a translator
  I want to view the sources list

  Scenario: View phrases
    Given someone has visited the hello world page
    And I am a translator
    When I go to the sources list
    Then I should see "Sources List" within "h1"
    And I should see "hello#world"
    When I follow "hello#world"
    Then I should see "Show Source"
    And I should see "hello#world"
    And I should see "hello/world"
    And I should see "true"


