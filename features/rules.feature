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
    And I should see the rule type "possessive"

  Scenario: Add rules--general rule
    Given I am a translation admin
    And I have the language "English" with short "en"
    
    When I go to the language page
    And I press "Add rule" 
    And I fill in "Description:" with "test rule"
    And I select "ends with" from "otwtranslation_context_rule[conditions][]"
    And I fill in "otwtranslation_context_rule[conditions][]" with "foobar"
    And I select "append" from "otwtranslation_context_rule[actions][]"
    And I fill in "otwtranslation_context_rule[actions][]" with "barbaz"
    And I press "Add rule"

    Then I should see the language name "English"
    And I should see the rule type "general"
    And I should see the rule description "test rule"
    And I should see the rule condition "ends with"
    And I should see the rule condition "foobar"
    And I should see the rule action "append"
    And I should see the rule action "barbaz"

  Scenario: Add rules--switch rule type
    Given I am a translation admin
    And I have the language "English" with short "en"
    
    When I go to the language page
    And I press "Add rule" 
    And I select "list" from "Type:"
    And I press "Set type"
    And I select "has more elements than" from "otwtranslation_context_rule[conditions][]"
    And I select "list to sentence" from "otwtranslation_context_rule[actions][]"
    And I press "Add rule"

    Then I should see the rule type "list"
    And I should see the rule condition "has more elements than"
    And I should see the rule action "list to sentence"


  Scenario: Edit rules
    Given I am a translation admin
    And I have the "possessive" rule for the language "English"
    
    When I go to the language page
    And press "Edit"
    And I fill in "Description:" with "new description"
    And I select "ends with" from "otwtranslation_context_rule[conditions][]"
    And I fill in "otwtranslation_context_rule[conditions][]" with "new cond"
    And I select "append" from "otwtranslation_context_rule[actions][]"
    And I fill in "otwtranslation_context_rule[actions][]" with "new action"
    And I press "Update rule"

    Then I should see the language name "English"
    And I should see the rule description "new description"
    And I should see the rule condition "ends with"
    And I should see the rule condition "new cond"
    And I should see the rule action "append"
    And I should see the rule action "new action"

