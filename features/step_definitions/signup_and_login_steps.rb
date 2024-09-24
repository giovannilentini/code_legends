# features/step_definitions/signup_and_login_steps.rb

Given("I am on the registration page") do
  visit signup_url
end

When("I register with {string}, {string}, {string}") do |username, email, password|
  fill_in 'user_username', with: username
  fill_in 'user_email', with: email
  fill_in 'user_password', with: password
  click_button 'Sign Up'

  # Retrieve the user and their confirmation token
  @user = User.find_by(email: email)
  @confirmation_token = @user.confirmation_token
end

Then("I receive an email confirmation link") do
  @confirmation_link = confirm_email_url(token: @confirmation_token)
end

When("I visit the confirmation link") do
  visit @confirmation_link
end

Then("I should see a confirmation success message") do
  # Check for the flash message within the right container or class
  expect(page).to have_selector('.flash-notice', text: 'Please check your email to confirm your account.')
end

When("I log in with {string} and {string}") do |email, password|
  visit login_path
  fill_in 'email', with: email
  fill_in 'password', with: password
  click_button 'Login'
end

Then("I should see a successful login message") do
  expect(page).to have_content('My Profile')
end

And("an user with email {string} and password {string} exists") do |email, password|
  RegisteredUser.create!(email: email, username: "test", password: password)
end

Then("I should get the error {string}") do |message|
  expect(page).to have_content(message)
end


Given("I am on the login page") do
  visit login_path
end

When("I log in with my credentials") do
  visit login_path
  fill_in 'email', with: 'testuser@example.com'
  fill_in 'password', with: 'password'
  click_button 'Login'
end