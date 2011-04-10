Feature: Translation sources
  In order to manage sources
  As a translator
  I want to view the sources list

  Scenario: View phrases
    Given someone has visited the hello world page
    And I am a translator

    When I go to the sources list
    Then I should see the heading "Sources List"
    And I should see "hello#world" within "td.controller_action"

    When I follow "hello#world"
    Then I should see the heading "Show Source"
    And I should see "hello#world" within "dd.action"
    And I should see "hello/world" within "dd.url"
    And I should see "yes" within "dd.version"
    And I should see the phrase "Hello World!"
