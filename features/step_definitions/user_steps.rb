# features/step_definitions/user_steps.rb

Given("I am on the registration page") do
  visit new_user_path
end

When("I register with valid credentials") do
  fill_in 'Username', with: 'testuser'
  fill_in 'Email', with: 'testuser@example.com'
  fill_in 'Password', with: 'password'
  click_button 'Sign Up'

  # Retrieve the user and their confirmation token
  @user = User.find_by(email: 'testuser@example.com')
  @confirmation_token = @user.confirmation_token
end

Then("I should see a message to check my email") do
  expect(page).to have_content('Please check your email to confirm your account.')
end

Then("I receive an email confirmation link") do
  @confirmation_link = confirmation_email_url(token: @confirmation_token)
end

When("I visit the confirmation link") do
  visit @confirmation_link
end

Then("I should see a confirmation success message") do
  expect(page).to have_content('Your email has been confirmed.')
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

# Helper method to generate the confirmation email URL
def confirmation_email_url(token:)
  
  Rails.application.routes.url_helpers.confi(token: token, host: 'www.example.com')
end
