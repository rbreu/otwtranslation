Feature: Translations
  In order to translate
  As a translator
  I want to use the inline translation tool


  Scenario: bla
    Given I am a translator
    # if we don't have a no-js scenario first, authlogic problems ensue...
    # TODO: try to hunt that down

  @javascript
  Scenario: View translations
    Given I am a translator
    And I have selected the language Deutsch
    And I am on the hello world page

    When I follow "Enable Translation Tools"
    And I right-click on the hello world phrase
    Then I should see the inline translator
    Then show me the page
