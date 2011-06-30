Feature: Votes
  In order to find the best translations
  As a translator
  I want to vote on translations

  Scenario: Vote on translations
    Given I am a translator
    And I have selected the language Deutsch
    And I have the translation "Hallo Welt!" for "Hello world!" in Deutsch

    When I go to the phrase page
    Then I should see the translation "Hallo Welt!"
    And I should see the votes "0"

    When I press "Vote up" 
    Then I should see the votes "1"

    When I press "Vote down" 
    Then I should see the votes "-1"

  @javascript
  Scenario: Vote on translations with JavaScript
    Given I am a translator
    And I have selected the language Deutsch
    And I have the translation "Hallo Welt!" for "Hello world!" in Deutsch

    When I go to the phrase page
    Then I should see the translation "Hallo Welt!"
    And I should see the votes "0"

    When I press "Vote up" 
    Then I should see the votes "1"

    When I press "Vote down" 
    Then I should see the votes "-1"

