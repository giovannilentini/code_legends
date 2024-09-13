Feature: Password reset

  Scenario: Requesting a password reset
    Given a user exists with email "testuser@example.com"
    And I am on the password reset page
    When I request a password reset for "testuser@example.com"
    And I visit the password reset link
    When I submit a new password
    Then I should see a success message
