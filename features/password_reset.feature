Feature: Password reset

  Scenario: Requesting a password reset
    Given a user exists with email "testuser@example.com"
    And I am on the password reset page
    When I request a password reset for "testuser@example.com"
    And I visit the password reset link
    When I submit a new password
    Then I should be redirected in the login page
    Then I should see a success message

  Scenario: Requesting password reset for a user that doesn't exist
    Given I am on the password reset page
    When I request a password reset for "testuser@example.com"
    Then I should see the error "Email not found"
    And I should be redirected in the homepage

  Scenario: Requesting password reset for a user that is registered with auth0
    Given a user exists with email "testuser@example.com"
    Given the user has registered with auth0
    And I am on the password reset page
    When I request a password reset for "testuser@example.com"
    Then I should see the error "User registered with oauth"
    And I should be redirected in the login page