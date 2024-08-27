require 'rails_helper'

RSpec.describe MatchesController, type: :feature do
  before do
    # Mock the JDoodle API request
    stub_request(:post, "https://api.jdoodle.com/v1/execute").
      with(
        body: {clientId: ENV["JDOODLE_CLIENT_ID"],clientSecret:ENV["JDOODLE_CLIENT_SECRET"],script:"Hello, World!",language:"python3",versionIndex:"0"}.to_json,
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: {output:"Hello, World!"}.to_json)
    # Create two sessions for two different users
    Capybara.using_session('user_1') do
      visit play_now_path
      select 'Python3', from: 'language'
      click_button 'Cerca Avversario'
    end

    Capybara.using_session('user_2') do
      visit play_now_path
      select 'Python3', from: 'language'
      click_button 'Cerca Avversario'
    end

  end
  it 'loads the result into the console element' do

    Capybara.using_session('user_1') do
      sleep(2)
      click_button 'Run Code'
      expect(page).to have_selector('#output', text: 'Hello, World!')

      # Wait for AJAX request to complete and check if the result is displayed
    end



  end
end

