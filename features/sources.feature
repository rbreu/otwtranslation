Feature: Translation sources
  In order to manage sources
  As a translator
  I want to view the sources list

  Scenario: View phrases
    Given someone has visited the hello world page
    And I am a translator
    When I go to the sources list
    Then I should see "Sources List" within "h2"
    And I should see "hello#world" within "td.controller_action"
    When I follow "hello#world"
    Then I should see "Show Source" within "h2"
    And I should see "hello#world" within "dd.controller_action"
    And I should see "hello/world" within "dd.url"
    And I should see "yes" within "dd.version"


