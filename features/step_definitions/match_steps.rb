# Given che esistono due utenti registrati
Given("che esistono due utenti registrati") do
  # Creazione del primo utente
  @player_1 = User.create!(
    username: 'player1',
    email: 'player1@example.com',
    password: 'password'
  )

  @player_1 = User.find_by(email: 'player1@example.com')
  @confirmation_token_1 = @player_1.confirmation_token

  # Creazione del secondo utente
  @player_2 = User.create!(
    username: 'player2',
    email: 'player2@example.com',
    password: 'password'
  )

  @player_2 = User.find_by(email: 'player2@example.com')
  @confirmation_token_2 = @player_2.confirmation_token
end

# And che esiste una partita con timer attivo tra questi due utenti
Given("che esiste una partita con timer attivo tra questi due utenti") do
  @challenge_proposal = ChallengeProposal.create!(title: "test", description: "test", test_cases: "test", user: @player_1)
  @challenge = Challenge.create!(title: "test", description: "test", difficulty: "hard", challenge_proposal_id: @challenge_proposal.id, code_template: 'class Solution:\n    def string_num_times(self, s: str, n: int) -> str:\n        return ""', test_template: '"if name == "main":\n    solution = Solution()\n\n    test_passed = 0\n\n    # Test cases\n    test_cases = [\n        ("Hello", 3, "HelloHelloHello"),\n        ("abc", 5, "abcabcabcabcabc"),\n        ("x", 10, "xxxxxxxxxx"),\n        ("", 5, ""),  # Empty string should return empty\n        ("Test", 0, ""),  # Repeating 0 times should return empty\n        ("Repeat", 1, "Repeat"),  # Repeating once should return the string itself\n        ("123", 3, "123123123"),\n        ("Hi", 4, "HiHiHiHi"),\n        ("!", 6, "!!!!!!"),\n        ("LongString", 2, "LongStringLongString")\n    ]\n\n    # Running tests\n    for i, (s, n, expected) in enumerate(test_cases):\n        result = solution.string_num_times(s, n)\n        if result == expected:\n            test_passed += 1\n        else:\n            if i < 3:  # For the first 3 tests, print the difference if they fail\n                print(f"Test {i+1} failed: expected \{expected}\', but got \'{result}\'")\n            else:\n                print(f"Test {i+1} failed")\n\n    if(test_passed==len(test_cases)):\n        print("Winner")\n    else:\n        print(f"Tests passed: {test_passed}/{len(test_cases)}")' )
  @match = Match.create!(
    status: "in_progress",
    player_1: @player_1,
    player_2: @player_2,
    timer_expires_at: 1.minute.from_now,
    challenge: @challenge
  )
end

# And la partita ha un timer che scade fra pochi secondi
And("la partita ha un timer che scade fra pochi secondi") do
  @match.update(timer_expires_at: 5.seconds.from_now)
end

# When passa il tempo e il timer scade
When("passa il tempo e il timer scade") do
  travel_to @match.timer_expires_at + 1.second
  page.driver.post("/matches/#{@match.id}/timeout")
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
When("un giocatore si arrende") do
  post "/matches/#{@match.id}/surrender"
end

# Then il giocatore che non si è arreso dovrebbe essere il vincitore
Then("il giocatore che non si è arreso dovrebbe essere il vincitore") do
  @match.reload
  winner = @match.player_2 == @player_1 ? @match.player_2 : @match.player_1
  expect(@match.winner_id).to eq(winner.id)
end
