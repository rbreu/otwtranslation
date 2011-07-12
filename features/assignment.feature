Feature: Translation phrases
  In order to manage translation work
  As a translation admin
  I want to create and edit assignments
  As a translator
  I want to complete assignment parts

  Scenario: View assignments
    Given I am a translation admin
    And I have selected the language Deutsch
    And I have an assignment for Deutsch

    When I go to the assignment table
    Then I should see the heading "Assignment Table"
    And I should see 1 assignment

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
    And I should see the assignment part status "pending"
    And I should see the assignee "Sam"
    And I should see the assignee "Dean"
    
    When I go to the assignment table
    Then I should see 1 assignment


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
    And I should see the assignment part status "pending"
    And I should see the assignee "Sam"
    And I should see the assignee "Dean"
    
    When I go to the assignment table
    Then I should see 1 assignment


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
    And I should see the assignment part status "pending"
    And I should see the assignee "Sam"
    And I should see the assignee "Dean"
    
    When I go to the assignment table
    Then I should see 1 assignment


  Scenario: Delete assignment
    Given I am a translation admin
    And I have selected the language Deutsch
    And I have an assignment for Deutsch
    
    When I go to the assignment table
    And I press "Delete" within "#assignment_navigation"
    Then I should see "Are you sure"

    When I press "Delete"
    Then I should see the heading "Assignment Table"
    And I should see 0 assignments


  @javascript
  Scenario: Delete assignment with JavaScript
    Given I am a translation admin
    And I have selected the language Deutsch
    And I have an assignment for Deutsch
    
    When I go to the assignment table
    And I press "Delete" within "#assignment_navigation"
    And I confirm the popup
    Then I should see the heading "Assignment Table"
    And I should see 0 assignments


  Scenario: Edit assignments
    Given I am a translation admin
    And I have selected the language Deutsch
    And I have an assignment for Deutsch

    When I go to the assignment page
    Then I should see the heading "Show Assignment"
    When I press "Edit"

    And I fill in "Description:" with "My new description"
    And I press "Update assignment"

    Then I should see the heading "Show Assignment"
    And I should see the assignment description "My new description"


  @javascript
  Scenario: Edit assignments with JavaScript
    Given I am a translation admin
    And I have selected the language Deutsch
    And I have an assignment for Deutsch

    When I go to the assignment page
    Then I should see the heading "Show Assignment"
    When I press "Edit"

    And I fill in "Description:" with "My new description"
    And I press "Update assignment"

    Then I should see the heading "Show Assignment"
    And I should see the assignment description "My new description"


  Scenario: Remove assignee from assignment
    Given I am a translation admin
    And I have selected the language Deutsch
    And I have an assignment for Deutsch
    And I have the assignees "Xena"

    When I go to the assignment page
    And I press "Delete" within ".assignment_part"
    Then I should see "Are you sure"

    When I press "Delete"
    Then I should see the heading "Show Assignment"
    And I should not see the assignee "Xena"


  @javascript
  Scenario: Remove assignee from assignment
    Given I am a translation admin
    And I have selected the language Deutsch
    And I have an assignment for Deutsch
    And I have the assignees "Xena"

    When I go to the assignment page
    And I press "Delete" within ".assignment_part"
    And I confirm the popup
    Then I should see the heading "Show Assignment"
    And I should not see the assignee "Xena"


  Scenario: Move assignment part up
    Given I am a translation admin
    And I have selected the language Deutsch
    And I have an assignment for Deutsch
    And I have the assignees "Xena, Gabrielle"

    When I go to the assignment page
    Then I should see "1. Xena"
    And I should see "2. Gabrielle"

    When I press "Move down"
    Then I should see "1. Gabrielle"
    And I should see "2. Xena"


  Scenario: Move assignment part up
    Given I am a translation admin
    And I have selected the language Deutsch
    And I have an assignment for Deutsch
    And I have the assignees "Xena, Gabrielle"

    When I go to the assignment page
    Then I should see "1. Xena"
    And I should see "2. Gabrielle"

    When I press "Move down"
    Then I should see "1. Gabrielle"
    And I should see "2. Xena"


  Scenario: Activate assignment
    Given I am a translation admin
    And I have selected the language Deutsch
    And I have an assignment for Deutsch
    And I have the assignees "Alice, Bob"
    And all emails have been delivered

    When I go to the assignment page
    Then I should see the activated status "no"

    When I press "Activate"
    Then I should see the heading "Show Assignment"
    And I should see the activated status "yes"
    And "Alice" should get 2 mails
    And "Bob" should get 1 mail


  @javacript
  Scenario: Activate assignment with JavaScript
    Given I am a translation admin
    And I have selected the language Deutsch
    And I have an assignment for Deutsch
    And I have the assignees "Alice, Bob"
    And all emails have been delivered

    When I go to the assignment page
    Then I should see the activated status "no"

    When I press "Activate"
    Then I should see the heading "Show Assignment"
    And I should see the activated status "yes"
    And "Alice" should get 2 mails
    And "Bob" should get 1 mail


  Scenario: Add an assignee
    Given I am a translation admin
    And I have the user "Uhura"
    And I have selected the language Deutsch
    And I have an assignment for Deutsch

    When I go to the assignment page
    And I press "Add assignee"
    And I fill in "Assignee's login:" with "Uhura"
    And I press "Add assignee"

    Then I should see the heading "Show Assignment"
    And I should see the assignee "Uhura"


  @javascript
  Scenario: Add an assignee with JavaScript
    Given I am a translation admin
    And I have the user "Uhura"
    And I have selected the language Deutsch
    And I have an assignment for Deutsch

    When I go to the assignment page
    And I press "Add assignee"
    And I fill in "Assignee's login:" with "Uhura"
    And I press "Add assignee"

    Then I should see the heading "Show Assignment"
    And I should see the assignee "Uhura"


  Scenario: Add an assignment from source page
    Given I am a translation admin
    And I have selected the language Deutsch
    And I have the source "foo#bar"

    When I go to the source page
    And I press "Add assignment"
    And I press "Add assignment"

    Then I should see the heading "Show Assignment"
    Then I should see the assignment source "foo#bar"

  @bla
  Scenario: Complete assignment parts
    Given I am a translator
    And I have selected the language Deutsch
    And I have an assignment for Deutsch
    And I have the assignees "Me, JackHarkness"
    And the assignment is activated
    And all emails have been delivered

    When I go to the translation homepage
    Then show me the page
    And I press "Mark my part as completed"
    And I fill in "notes" with "All done. :)"
    And I press "Complete assignment part"

    Then I should see the heading "Show Assignment"
    And I should see the assignment part status "completed"
    And I should see "All done. :)"
    And "JackHarkness" should get 1 mail
