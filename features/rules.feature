Feature: Context Rules
  In order to have rules
  As a translation admin
  I want to view and manage rules

  Scenario: View rules
    Given I am a translation admin
    And I have the "possessive" rule for the language "English"
    
    When I go to the language page
    Then I should see the language name "English"
    And I should see "Rules for this language"

  Scenario: Add rules
    Given I am a translation admin
    And I have the language "English" with short "en"
    
    When I go to the language page
    And I press "Add rule" 
    
