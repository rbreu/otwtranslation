Feature: Translations
  In order to translate
  As a translator
  I want to view translations
  And I want to create translations
  And I want to edit translations

  Scenario: View translations
    Given I have the translation "Hallo Welt!" for "Hello world!" in Deutsch
    And I have the translation "Hoi wereld!" for "Hello world!" in Nederlands
    And I am a translator

    When I select the language Deutsch
    And I go to the phrase page
    Then I should see the translation "Hallo Welt!"
    But I should not see "Hoi wereld!"

    When I follow "Show" 
    Then I should see the heading "Show Translation"
    Then I should see the translation "Hallo Welt!"

    When I select the language Italiano
    And I go to the phrase page
    Then I should see "There are no translations"

  Scenario: Add translations
    Given I have the phrase "Hello world!"
    And I have selected the language Deutsch
    And I am a translator

    When I go to the phrase page
    And I press "Add translation"
    And I fill in "Translation:" with "Hallo Welt!"
    And I press "Add translation"
    Then I should see "Show Phrase"
    And I should see the phrase "Hello world!"
    And I should see the translation "Hallo Welt!"
    And I should see approved set to "no"
    And I should see the translation rule "All"


  @javascript
  Scenario: Add translations with javascript
    Given I have the phrase "Hello world!"
    And I have selected the language Deutsch
    And I am a translator

    When I go to the phrase page
    And I press "Add translation"
    And I fill in "Translation:" with "Hallo Welt!"
    And I press "Add translation"
    Then I should see "Show Phrase"
    And I should see the phrase "Hello world!"
    And I should see the translation "Hallo Welt!"
    And I should see approved set to "no"


  Scenario: Add context-aware translations
    Given I have the phrase "You have {quantity::msg} messages!"
    And I have singular/plural rules for Deutsch
    And I have selected the language Deutsch
    And I am a translator

    When I go to the phrase page
    And I press "Add translation"
    And I press "Create context-aware translations"
    Then I should see "Show Phrase"
    And I should see 2 translations
    And I should see the translation rule "is"
    And I should see the translation rule "matches all"


  Scenario: Approve translations
    Given I have the translation "Akzeptiere mich!" for "Approve me!" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrase page
    Then I should see approved set to "no"
    When I press "Approve"
    Then I should see approved set to "yes"
    
  Scenario: Can't approve translations if approved translations exist
    Given I have the approved translation "Akzeptiere mich!" for "Approve me!" in Deutsch
    And I have the translation "Gib mich frei!" for "Approve me!" in Deutsch
    And I am a translator
    And I have selected the language Deutsch

    When I go to the phrase page
    And I press "Approve"
    Then I should see "Another translation is already approved."
    And I should see approved set to "no"
    
  @javascript
  Scenario: Approve translations with javascript
    Given I have the translation "Akzeptiere mich!" for "Approve me!" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrase page
    Then I should see approved set to "no"
    When I press "Approve"
    Then I should see approved set to "yes"
    
  @javascript
  Scenario: Can't approve translations if approved translations exist with javascript
    Given I have the approved translation "Akzeptiere mich!" for "Approve me!" in Deutsch
    And I have the translation "Gib mich frei!" for "Approve me!" in Deutsch
    And I am a translator
    And I have selected the language Deutsch

    When I go to the phrase page
    And I press "Approve"
    Then I should see "Another translation is already approved."
    And I should see approved set to "no"
    
    
  Scenario: Disapprove translations
    Given I have the approved translation "Lehne mich ab :(" for "Disapprove me :(" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrase page
    Then I should see approved set to "yes"
    When I press "Disapprove"
    Then I should see "Are you sure"
    When I press "Disapprove"
    Then I should see approved set to "no"

  @javascript
  Scenario: Disapprove translations with javascsript
    Given I have the approved translation "Lehne mich ab :(" for "Disapprove me :(" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrase page
    Then I should see approved set to "yes"
    When I press "Disapprove"
    And I confirm the popup
    Then I should see approved set to "no"

  Scenario: Delete translations
    Given I have the translation "Lösch mich :(" for "Delete me :(" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrase page
    And I press "Delete"
    Then I should see "Are you sure"
    When I press "Delete"
    Then I should not see "Lösch mich :("

  @javascript
  Scenario: Delete translations with javascript
    Given I have the translation "Lösch mich :(" for "Delete me :(" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrase page
    And I press "Delete"
    And I confirm the popup
    Then I should not see "Lösch mich :("

  Scenario: Edit translations
    Given I have the translation "Ändere mich!" for "Change me!" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrase page
    And I press "Edit"
    And I fill in "Translation:" with "Editiere mich!"
    And I press "Update translation"

    Then I should see the heading "Show Translation"
    And I should see the translation "Editiere mich!"
    And I should not see "Ändere mich!"


  @javascript  
  Scenario: Edit translations with Javascript
    Given I have the translation "Ändere mich!" for "Change me!" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrase page
    And I press "Edit"
    And I fill in "Translation:" with "Editiere mich!"
    And I press "Update translation"

    And I should see the translation "Editiere mich!"
    And I should not see "Ändere mich!"
