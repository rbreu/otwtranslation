Feature: Translations
  In order to translate
  As a translator
  I want to view translations
  And I want to create translations
  And I want to edit translations

  Scenario: View translations
    Given I have the translation "Hallo Welt!" for "Hello world!" in Deutsch
    Given I have the translation "Hoi wereld!" for "Hello world!" in Nederlands
    And I have selected the language Deutsch
    And I am a translator

    When I go to the phrases list
    And I follow "Hello world!"
    Then I should see "Hallo Welt!" within "p.label"
    And I should see "no" within "dd.approved"
    And I should not see "Hoi wereld!"

    When I select the language Italiano
    And I go to the phrases list
    And I follow "Hello world!"
    Then I should see "There are no translations"

  Scenario: Add translations
    Given I have the phrase "Hello world!"
    And I have selected the language Deutsch
    And I am a translator

    When I go to the phrases list
    And I follow "Hello world!"
    And I follow "Add translation"
    And I fill in "Translation:" with "Hallo Welt!"
    And I press "Add translation"
    Then I should see "Translation successfully created."
    And I should see "Show Phrase"
    And I should see "Hello world!" within "dd.label"
    And I should see "Hallo Welt!" within "p.label"

    
