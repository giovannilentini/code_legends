Feature: User Registration and Email Confirmation

  Scenario: User registers and confirms their email
    Given I am on the registration page
    When I register with valid credentials
    And I receive an email confirmation link
    When I visit the confirmation link
    When I log in with my credentials
    Then I should see a successful login message
