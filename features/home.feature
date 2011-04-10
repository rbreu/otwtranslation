Feature: Translation home page
  In order to manage translations on the archive
  As a translator
  I want to view the translation home page
  And use the translation tools

  Scenario: Translation tools appear in the footer
    Given I am a translation admin
    When I go to the home page
    Then I should see "Enable Translation Tools" in the footer

  Scenario: Enable/Disable translation tools
    Given I am a translation admin
    And I have selected the language Deutsch
    And I am on the home page
  
    When I follow "Enable Translation Tools"
    Then I should see "Disable Translation Tools" in the footer
    And I should see the translation toolbar
    And I should see marked phrases

    When I follow "Disable Translation Tools"
    Then I should see "Enable Translation Tools" in the footer
    But I should not see the translation toolbar
    And I should not see marked phrases

  Scenario: View the translation home page
    Given I am a translation admin
    When I go to the translation home page
    Then I should see the heading "Translation Home"

