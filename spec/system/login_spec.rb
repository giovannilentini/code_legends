require 'rails_helper'
RSpec.describe 'Login', type: :system do
  it 'allows a user to log in' do
    # Visit the login page
    visit login_path

    # Fill in the login form
    fill_in 'E-mail', with: 'user@example.com'
    fill_in 'Password', with: 'password'

    # Click the login button
    click_on 'Login'

    # Assert that the user is logged in successfully
    expect(page).to have_text('Logged in successfully')
  end
end

