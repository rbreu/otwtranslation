Feature: Translation home page
  In order to manage translations on the archive
  As a translator
  I want to view the translation home page
  And use the translation tools

  Scenario: Use the translation tools
    Given I am a translation admin

    When I go to the home page
    Then I should see "Enable Translation Tools" within "#footer"

    When I follow "Enable Translation Tools" within "#footer"
    Then I should see "Disable Translation Tools" within "#footer"
    And I should see "translation home" within "#header"
    And I should see "sources" within "#header"
    And I should see "phrases" within "#header"

    When I follow "Disable Translation Tools" within "#footer"
    Then I should see "Enable Translation Tools" within "#footer"
    And I should not see "translation home" within "#header"
    And I should not see "sources" within "#header"
    And I should not see "phrases" within "#header"


  Scenario: View the translation home page
    Given I am a translation admin
    When I go to the translation home page
    Then I should see "Translation Home" within "h2"
