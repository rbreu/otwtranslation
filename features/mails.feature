Feature: Translation phrases
  In order to translate mails
  As a translator
  I want to view mail template online


  Scenario: View mails
    Given I am a translation admin

    When I go to the mail index
    Then I should see the heading "Mails"
    Then I should see "test_notification.html.erb"

    When I follow "test_notification.html.erb"
    Then I should see the heading "Show Mail"
    And I should see "Hello DUMMY!"

