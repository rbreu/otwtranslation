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

