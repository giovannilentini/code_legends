require 'application_system_test_case'

class LoginTest < ApplicationSystemTestCase
  test 'user can log in' do
    visit login_path

    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    assert_text 'Logged in successfully'
  end
end