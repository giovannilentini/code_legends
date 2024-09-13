Feature: User login
  As a user
  I want to log in to my account
  So I can access personalized features

  Scenario: User logs in successfully
    Given I am on the home page
    When I press "Login"
    And I fill in "Email" with "user@example.com"
    And I fill in "Password" with "password"
    And I press "Log in"
    Then I should see the Logged Homepage
