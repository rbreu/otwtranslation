Feature: Translations
  In order to translate
  As a translator
  I want to view translations
  And I want to create translations
  And I want to edit translations

  Scenario: View translations
    Given I have the translation "Hallo Welt!" for "Hello world!" in Deutsch
    And I have the translation "Hoi wereld!" for "Hello world!" in Nederlands
    And I have selected the language Deutsch
    And I am a translator

    When I go to the phrases list
    And I follow "Hello world!"
    Then I should see "Hallo Welt!" within "p.label"
    And I should see "no" within "dd.approved"
    And I should not see "Hoi wereld!"
    When I follow "Show" 
    Then I should see "Hallo Welt!"

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
    And I press "Add translation"
    And I fill in "Translation:" with "Hallo Welt!"
    And I press "Add translation"
    Then I should see "Show Phrase"
    And I should see "Hello world!" within "dd.label"
    And I should see "Hallo Welt!" within "p.label"

  @javascript
  Scenario: Add translations with javascript
    Given I have the phrase "Hello world!"
    And I have selected the language Deutsch
    And I am a translator

    When I go to the phrases list
    And I follow "Hello world!"
    And I press "Add translation"
    And I fill in "Translation:" with "Hallo Welt!"
    And I press "Add translation"
    Then I should see "Show Phrase"
    And I should see "Hello world!" within "dd.label"
    And I should see "Hallo Welt!" within "p.label"

  Scenario: Approve translations
    Given I have the translation "Akzeptiere mich!" for "Approve me!" in Deutsch
    And I have the translation "Gib mich frei!" for "Approve me!" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrases list
    And I follow "Approve me!"
    Then I should see "no" within "li.even dd.approved"
    When I press "Approve" within "li.even"
    Then I should see "yes" within "li.even dd.approved"

    When I press "Approve" within "li.odd"
    Then I should see "Another translation is already approved."
    And I should see "no" within "li.odd dd.approved"
    
  @javascript
  Scenario: Approve translations with javascript
    Given I have the translation "Akzeptiere mich!" for "Approve me!" in Deutsch
    And I have the translation "Gib mich frei!" for "Approve me!" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrases list
    And I follow "Approve me!"
    Then I should see "no" within "li.even dd.approved"
    When I press "Approve" within "li.even"
    Then I should see "yes" within "li.even dd.approved"

    When I press "Approve" within "li.odd"
    Then I should see "Another translation is already approved."
    And I should see "no" within "li.odd dd.approved"
    
  Scenario: Disapprove translations
    Given I have the approved translation "Lehne mich ab :(" for "Disapprove me :(" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrases list
    And I follow "Disapprove me :("
    Then I should see "yes" within "dd.approved"
    When I press "Disapprove"
    Then I should see "Are you sure"
    When I press "Disapprove"
    Then I should see "no" within "dd.approved"

  @javascript
  @wip
  Scenario: Disapprove translations with javascsript
    # As is the test should pass but doesn't...

    Given I have the approved translation "Lehne mich ab :(" for "Disapprove me :(" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
    #And I will confirm the popup
    And I won't confirm the popup
 
    When I go to the phrases list
    And I follow "Disapprove me :("
    Then I should see "yes" within "dd.approved"
    When I press "Disapprove"
    # Here's the popup that's to be confirmed
    Then I should see "no" within "dd.approved"

  Scenario: Delete translations
    Given I have the translation "Lösch mich :(" for "Delete me :(" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrases list
    And I follow "Delete me :("
    And I follow "Show"
    And I press "Delete"
    Then I should see "Are you sure"
    When I press "Delete"
    Then I should not see "Lösch mich :("

  @javascript
  @wip
  Scenario: Delete translations
    # As is the test should fail, but doesn't...

    Given I have the translation "Lösch mich :(" for "Delete me :(" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
    #And I will confirm the popup
    And I won't confirm the popup
 
    When I go to the phrases list
    And I follow "Delete me :("
    And I follow "Show"
    And I press "Delete"
    # Here's the popup that's to be confirmed
    Then I should not see "Lösch mich :("
    And I should see "There are no translations"


  Scenario: Edit translations
    Given I have the translation "Ändere mich!" for "Change me!" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrases list
    And I follow "Change me!"
    And I press "Edit"
    And I fill in "Translation:" with "Editiere mich!"
    And I press "Update translation"

    Then I should see "Show Translation"
    And I should see "Editiere mich!" within "p.label"
    And I should not see "Ändere mich!"


  @javascript  
  Scenario: Edit translations with Javascript
    Given I have the translation "Ändere mich!" for "Change me!" in Deutsch
    And I have selected the language Deutsch
    And I am a translator
 
    When I go to the phrases list
    And I follow "Change me!"
    And I press "Edit"
    And I fill in "Translation:" with "Editiere mich!"
    And I press "Update translation"

    And I should see "Editiere mich!" within "p.label"
    And I should not see "Ändere mich!"
