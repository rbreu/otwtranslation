Feature: Translations
  In order to translate
  As a translator
  I want to view translations
  And I want to create translations
  And I want to edit translations

  Scenario: View translations
    Given I have the phrase "Hello world!"
    And I have the translation "Hallo Welt!" for "Hello world!" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
    When I go to the phrases list
    And I follow "Hello world!"
    Then I should see "Hallo Welt!"
    When I follow "Hallo Welt!"
    Then I should see "Translation" within "h2"
    And I should see "Hallo Welt!"


