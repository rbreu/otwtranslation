Feature: Translation phrases
  In order to manage translation work
  As a translation admin
  I want to create and edit assignments

  Scenario: View assignments
    Given I am a translation admin
    And I have selected the language Deutsch
    And I have an assignment for Deutsch

    When I go to the assignment table
    Then I should see the heading "Assignment Table"
    And I should see 1 assignments

    When I select the language Nederlands
    And I go to the assignment table
    Then I should see 0 assignments


  Scenario: Add an assignment
    Given I am a translation admin







