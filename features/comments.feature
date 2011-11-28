Feature: Translation comments
  In order to discuss translations
  As a translator
  I want to add, view and delete comments

  Scenario: Add comment without JavaScript
    Given I have the translation "Hallo Welt!" for "Hello world!" in Deutsch
    And I am a translator

    When I go to the translation page
    Then I should see the comments "0"

    When I fill in "comment[content]" with "This is great!"
    And I press "Comment"
    Then I should see "Comment created!"
    And I should see the comment "This is great!"
    And I should see the comments "1"

  @javascript
  Scenario: Add comment with JavaScript
    Given I have the translation "Hallo Welt!" for "Hello world!" in Deutsch
    And I am a translator

    When I go to the translation page
    Then I should see the comments "0"

    When I fill in "comment[content]" with "This is great!"
    And I press "Comment"
    Then I should see "Comment created!"
    And I should see the comment "This is great!"
    And I should see the comments "1"

  Scenario: Show/Hide comments
    Given I have a translation with 2 comments
    And I am a translator

    When I go to the translation page
    Then I should see the comments "2"
    And I should see 0 comment blurbs
    
    When I follow "Comments 2"
    Then show me the page
    Then I should see 2 comment blurbs
    When I follow "Hide Comments 2"
    Then I should see 0 comment blurbs

  @javascript
  Scenario: Show/Hide comments with JavaScript
    Given I have a translation with 2 comments
    And I am a translator

    When I go to the translation page
    Then I should see the comments "2"
    And I should see 0 comment blurbs
    
    When I follow "Comments 2"
    Then I should see 2 comment blurbs
    When I follow "Hide Comments 2"
    Then I should see 0 comment blurbs

  Scenario: Delete comments
    When "issue 2523 (deleting comments without JS" is fixed

  @javascript
  Scenario: Delete comments with JavaScript
    Given I am a translator 
    And I have a translation with 2 comments

    When I go to the translation page
    And I follow "Comments 2"
    And I follow "Delete" within ".feedback"
    And I follow "Yes, delete!"
    Then I should see "Comment deleted"
    And I should see the comments "1"


  Scenario: Send comments notification to last editor
    Given I have the translation "Hallo Welt!" for "Hello world!" in Deutsch
    And the translation was last edited by "batman"
    And I am a translator
    And all emails have been delivered

    When I go to the translation page
    And I fill in "comment[content]" with "This is great!"
    And I press "Comment"

    Then "batman" should get 1 mail
