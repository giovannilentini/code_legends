# Given che esistono due utenti registrati
Given("che esistono due utenti registrati") do
  # Creazione del primo utente
  @player_1 = RegisteredUser.create!(
    username: 'player1',
    email: 'player1@example.com',
    password: 'password',
    email_confirmed_at: Time.now,
  )
  # Creazione del secondo utente
  @player_2 = RegisteredUser.create!(
    username: 'player2',
    email: 'player2@example.com',
    password: 'password',
    email_confirmed_at: Time.now
  )
end

And("gli utenti sono loggati") do
  Capybara.using_session("player1") do
    visit login_path
    fill_in 'email', with: @player_1.email
    fill_in 'password', with: @player_1.password
    click_button 'Login'
    expect(page).to have_content("My Profile")
  end
  Capybara.using_session("player2") do
    visit login_path
    fill_in 'email', with: @player_2.email
    fill_in 'password', with: @player_2.password
    click_button 'Login'
    expect(page).to have_content("My Profile")
  end

end

# And che esiste una partita con timer attivo tra questi due utenti
Given("che esiste una partita con timer breve attivo tra questi due utenti") do
  @challenge = Challenge.create!(
    title: "test",
    description: "test",
    difficulty: "hard",
    language:"python3",
    code_template: <<~PYTHON_CODE,
      class Solution:
          def string_num_times(self, s: str, n: int) -> str:
              return ""
    PYTHON_CODE
    test_template: <<~PYTHON_TESTS
      if __name__ == "main":
          solution = Solution()

          test_passed = 0

          # Test cases
          test_cases = [
              ("Hello", 3, "HelloHelloHello"),
              ("abc", 5, "abcabcabcabcabc"),
              ("x", 10, "xxxxxxxxxx"),
              ("", 5, ""),  
          ]
          for i, (s, n, expected) in enumerate(test_cases):
              result = solution.string_num_times(s, n)
              if result == expected:
                  test_passed += 1
              else:
                  if i < 3:  # For the first 3 tests, print the difference if they fail
                      print(f"Test {i+1} failed: expected '{expected}', but got '{result}'")
                  else:
                      print(f"Test {i+1} failed")

          if test_passed == len(test_cases):
              print("Winner")
          else:
              print(f"Tests passed: {test_passed}/{len(test_cases)}")
    PYTHON_TESTS
  )
  @match = Match.create!(
    status: "ongoing",
    player_1: @player_1,
    player_2: @player_2,
    challenge: @challenge,
    timer_expires_at: 2.seconds.from_now,
    language: "python3"
  )
end

Given("che esiste una partita con timer attivo tra questi due utenti") do
  @challenge = Challenge.create!(
    title: "test",
    language:"python3",
    description: "test",
    difficulty: "hard",
    code_template: <<~PYTHON_CODE,
      class Solution:
          def string_num_times(self, s: str, n: int) -> str:
              return ""
    PYTHON_CODE
    test_template: <<~PYTHON_TESTS
      if __name__ == "main":
          solution = Solution()

          test_passed = 0

          # Test cases
          test_cases = [
              ("Hello", 3, "HelloHelloHello"),
              ("abc", 5, "abcabcabcabcabc"),
              ("x", 10, "xxxxxxxxxx"),
              ("", 5, ""),  
          ]
          for i, (s, n, expected) in enumerate(test_cases):
              result = solution.string_num_times(s, n)
              if result == expected:
                  test_passed += 1
              else:
                  if i < 3:  # For the first 3 tests, print the difference if they fail
                      print(f"Test {i+1} failed: expected '{expected}', but got '{result}'")
                  else:
                      print(f"Test {i+1} failed")

          if test_passed == len(test_cases):
              print("Winner")
          else:
              print(f"Tests passed: {test_passed}/{len(test_cases)}")
    PYTHON_TESTS
  )
  @match = Match.create!(
    status: "ongoing",
    player_1: @player_1,
    player_2: @player_2,
    challenge: @challenge,
    timer_expires_at: 10.minutes.from_now,
    language: "python3"
  )
end


And("l'utente {string} è nella pagina della partita") do |player|
  Capybara.using_session("#{player}") do
    visit match_path(@match)
    expect(page).to have_content("Change Theme")
  end
end

Then('un timer è presente') do
  Capybara.using_session("player1") do
    expect(page).to have_selector('#timer', visible:true, wait:2)
  end
  Capybara.using_session("player2") do
    expect(page).to have_selector('#timer', visible:true, wait:2)
  end

end

When('il timer scade') do
  @match.update(timer_expires_at: Time.now)
  # Simulate the timer expiring by manipulating JavaScript
  Capybara.using_session("player1") do
    page.execute_script <<-JS
      const timerElement = document.getElementById('timer');
      const timerExpiresAt = new Date(Date.now() - 10000); // Set to 10 seconds in the past
      const matchId = '#{@match.id}';

      // Start the timer
      window.setTimer(timerExpiresAt, matchId, timerElement);
    JS
  end
  sleep(2)
end

Then("un popup con il risultato viene mostrato al {string} con il messaggio {string}") do |player, message|
  Capybara.using_session("#{player}") do
    expect(page).to have_selector(".popup-content", visible: true)
    expect(page).to have_content("#{message}")
  end
end
# Then la partita dovrebbe essere segnata come "finita"
Then("la partita dovrebbe essere segnata come {string}") do |status|
  @match.reload
  expect(@match.status).to eq(status)
end

# And non dovrebbe essere assegnato alcun vincitore
And("non dovrebbe essere assegnato alcun vincitore") do
  expect(@match.winner_id).to be_nil
end

# And un giocatore si arrende
When("l'utente {string} si arrende") do |player|
  Capybara.using_session("#{player}") do
    click_button "surrender-submit"
  end
end

# Then il giocatore che non si è arreso dovrebbe essere il vincitore
Then("il giocatore che non si è arreso dovrebbe essere il vincitore") do
  @match.reload
  expect(@match.winner_id).to eq(@player_2.id)
end

Given("api esterna") do
  stub_request(:post, "https://code-compiler.p.rapidapi.com/v2")
    .to_return(
      status: 200,
      body: { Result: "Winner", Errors: nil }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
end

When("il {string} manda il codice giusto") do |player|
  Capybara.using_session("#{player}") do
    click_button "submit-code"
  end
end

And("l'utente {string} dovrebbe essere il vincitore") do |player|

  case player
  when "player1"
    winner = @player_1.id
  when "player2"
    winner = @player_2.id
  end

  @match.reload
  expect(@match.winner_id).to eq(winner)
end


And("gli utenti aspettano la connessione con gli ActionCable") do
  Capybara.using_session("player1") do
    Timeout.timeout(5) do
      loop until ActionCable.server.connections.any?
    end
  end
  Capybara.using_session("player2") do
    Timeout.timeout(5) do
      loop until ActionCable.server.connections.any?
    end
  end
end


Then("è presente la scritta {string}") do |string|
  Capybara.using_session("player1") do
    expect(page).to have_content(string)
  end
  Capybara.using_session("player2") do
    expect(page).to have_content(string)
  end
end

Then("il {string} manda un messaggio") do |player|
  Capybara.using_session("#{player}") do
    fill_in "chat-input", with: "Test Messaggio"
    click_button "send-msg"
  end
end
Then("il {string} riceve il messaggio") do |player|
  Capybara.using_session("#{player}") do
    expect(page).to have_content("Test Messaggio")
  end
end
And("gli utenti sono sulla sezione chat") do
  Capybara.using_session("player1") do
    click_button "chatBtn"
  end
  Capybara.using_session("player2") do
    click_button "chatBtn"
  end
end