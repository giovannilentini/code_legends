# features/step_definitions/user_steps.rb

Given("I am on the registration page") do
  visit signup_url
end

When("I register with valid credentials") do
  fill_in 'user_username', with: 'testuser'
  fill_in 'user_email', with: 'testuser@example.com'
  fill_in 'user_password', with: 'password'
  click_button 'Sign Up'

  # Retrieve the user and their confirmation token
  @user = User.find_by(email: 'testuser@example.com')
  @confirmation_token = @user.confirmation_token
end


Then("I receive an email confirmation link") do
  @confirmation_link = confirm_email_url(token: @confirmation_token)
end

When("I visit the confirmation link") do
  visit @confirmation_link
end

Then("I should see a message to check my email") do
  # Check for the flash message within the right container or class
  expect(page).to have_selector('.flash-notice', text: 'Please check your email to confirm your account.')
end

When("I log in with my credentials") do
  visit login_path
  fill_in 'Email', with: 'testuser@example.com'
  fill_in 'Password', with: 'password'
  click_button 'Log in'
end

Then("I should see a successful login message") do
  expect(page).to have_content('Logged in successfully')
end
