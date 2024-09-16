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
end

When("I visit the password reset link") do

  @user.reload
  @reset_token = @user.reset_token
  @reset_link = password_reset_edit_url(token: @reset_token)
  visit @reset_link

end

When("I submit a new password") do
  fill_in 'password_field', with: 'newpassword'
  click_button 'Reset Password'
end

Then("I should see a success message") do
  # Ensure the success message is present on the login page
  expect(page).to have_content('LOGIN')
end


Then("I should see the error {string}") do |message|
  expect(page).to have_content(message)
end

And("I should be redirected in the homepage") do
  expect(page).to have_current_path(root_path)
end


Given("the user has registered with auth0") do
  @user.update(auth0_id: "auth0-id")
end

And("I should be redirected in the login page") do
  expect(page).to have_current_path(login_path)
end