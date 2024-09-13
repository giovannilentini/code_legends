module AuthenticationHelpers
  def login_as(user)
    visit login_path
    fill_in 'email', with: 'testuser@example.com'
    fill_in 'password', with: 'password'
    click_button 'Login'
  end
end

World(AuthenticationHelpers)  # This makes the helper methods available in your step definitions