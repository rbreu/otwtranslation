Feature: Home
  
  Scenario: View the home page
    Given I have a rails application
      And I start the rails application
    When I go to /translation
      Then I should see "Translation home"
