# features/step_definitions/password_reset_steps.rb

Given("a user exists with email {string}") do |email|
  @user = User.create!(
    username: 'testuser',
    email: email,
    password: 'oldpassword',
  )
end

Given("I am on the password reset page") do
  visit password_reset_path
end

When("I request a password reset for {string}") do |email|
  fill_in 'email', with: email
  click_button 'Send Reset Instructions'

  # Simulate sending the password reset email
  @user.generate_password_reset_token!
  @reset_token = @user.reset_token
  @reset_link = password_reset_edit_url(token: @reset_token)
end

When("I visit the password reset link") do
  visit @reset_link
end

When("I submit a new password") do
  fill_in 'password_field', with: 'newpassword'
  click_button 'Reset Password'

  # Wait for redirection to the login page
  expect(page).to have_current_path(login_path)
end

Then("I should see a success message") do
  # Ensure the success message is present on the login page
  expect(page).to have_content('LOGIN')
end



