Feature: User Registration and Email Confirmation

  Scenario: User registers and confirms their email
    Given I am on the registration page
    When I register with "testusername", "testuser@example.com", "password"
    And I receive an email confirmation link
    When I visit the confirmation link
    When I log in with "testuser@example.com" and "password"
    Then I should see a successful login message

  Scenario: User trying to signup with existing email
    Given I am on the registration page
    And an user with email "testuser@example.com" and password "password" exists
    When I register with "testusername", "testuser@example.com", "password"
    Then I should get the error "User with mail testuser@example.com already exists"


  Scenario: User trying to signup with email that needs to be confirmed
    Given I am on the registration page
    And an user with email "testuser@example.com" and password "password" exists
    When I register with "testusername", "testuser@example.com", "password"
    Then I should get the error "User with mail testuser@example.com already exists"


  Scenario: User trying to login with email that needs to be confirmed
    Given I am on the login page
    And an user with email "testuser@example.com" and password "password" exists
    When I log in with "testuser@example.com" and "password"
    Then I should get the error "Confirm email first"