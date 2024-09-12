require 'rails_helper'

RSpec.describe "UserProfile", type: :system do
  let!(:user) { User.create!(auth0_id: "auth0|12345", email: "test@example.com") }
  
  before do
    driven_by(:selenium_chrome_headless) # Assicurati che questo driver sia configurato

    # Crea una proposta di sfida con tutti i parametri richiesti
    challenge_proposal = ChallengeProposal.create!(
      title: "Challenge Title",
      description: "Challenge Description",
      status: "accepted",
      user: user,
      test_cases: "Sample Test Cases"
    )

    # Crea sfide accettate e rifiutate
    Challenge.create!(
      description: "Accepted Challenge",
      status: "accepted",
      challenge_proposal: challenge_proposal,
      title: "Accepted Title"
    )
    Challenge.create!(
      description: "Rejected Challenge",
      status: "rejected",
      rejection_reason: "Too simple",
      challenge_proposal: challenge_proposal,
      title: "Rejected Title"
    )
  end

  it "shows accepted challenges" do
    visit "/users/#{user.id}"  # Usa il percorso corretto con l'ID utente

    # Verifica che la challenge accettata sia visibile
    expect(page).to have_content("Accepted Challenge")
  end

  it "shows rejected challenges with reasons" do
    visit "/users/#{user.id}"  # Usa il percorso corretto con l'ID utente

    # Verifica che la challenge rifiutata sia visibile
    expect(page).to have_content("Rejected Challenge")
    expect(page).to have_content("Too simple")
  end
end
