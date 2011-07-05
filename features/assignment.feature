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
    And I have the user "Sam"
    And I have the user "Dean"
    And I have selected the language Deutsch
    
    When I go to the assignment table
    And I press "Add assignment"
    Then I should see the heading "Add Assignment"

    When I fill in the following:
      | Source:      | home#index       |
      | Description: | Test description |
      | Assign to:   | Sam, Dean        |
    And I press "Add assignment"

    Then I should see the heading "Show Assignment"
    And I should see the assignment description "Test description"
    And I should see the assignment source "home#index"
    And I should see the completed status "false"
    And I should see the assignee "Sam"
    And I should see the assignee "Dean"
    
    When I go to the assignment table
    Then I should see 1 assignments


  Scenario: Add an assignment with invalid source
    Given I am a translation admin
    And I have the user "Sam"
    And I have the user "Dean"
    And I have selected the language Deutsch
    
    When I go to the assignment table
    And I press "Add assignment"
    Then I should see the heading "Add Assignment"

    When I fill in the following:
      | Source:      | sdf              |
      | Description: | Test description |
      | Assign to:   | Sam, Dean        |
    And I press "Add assignment"
    Then I should see "There was a problem"

    When I fill in "Source:" with "home#index"
    And I press "Add assignment"

    Then I should see the heading "Show Assignment"
    And I should see the assignment description "Test description"
    And I should see the assignment source "home#index"
    And I should see the completed status "false"
    And I should see the assignee "Sam"
    And I should see the assignee "Dean"
    
    When I go to the assignment table
    Then I should see 1 assignments


  Scenario: Add an assignment with invalid user
    Given I am a translation admin
    And I have the user "Sam"
    And I have the user "Dean"
    And I have selected the language Deutsch
    
    When I go to the assignment table
    And I press "Add assignment"
    Then I should see the heading "Add Assignment"

    When I fill in the following:
      | Source:      | home#index       |
      | Description: | Test description |
      | Assign to:   | Sam, Castiel     |
    And I press "Add assignment"
    Then I should see "There was a problem"

    When I fill in "Assign to:" with "Sam, Dean"
    And I press "Add assignment"

    Then I should see the heading "Show Assignment"
    And I should see the assignment description "Test description"
    And I should see the assignment source "home#index"
    And I should see the completed status "false"
    And I should see the assignee "Sam"
    And I should see the assignee "Dean"
    
    When I go to the assignment table
    Then I should see 1 assignments






