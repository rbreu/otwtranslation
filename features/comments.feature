Feature: Translation comments
  In order to discuss translations
  As a translator
  I want to add comments
  And I want to view comments
  And I want to reply to comments

  Scenario: Add comment without JavaScript
    Given I have the translation "Hallo Welt!" for "Hello world!" in Deutsch
    And I am a translator

    When I go to the translation page
    Then I should see the comments "0"

    When I press "Add Comment"
    And I fill in "comment_form" with "This is great!"
    And I press "Add Comment"
    
    Then I should see the comment "This is great!"
    And I should see the comments "1"
