require 'rails_helper'

RSpec.describe "AdminProfile", type: :system do

  it "shows only challenges with status -1" do
    Challenge.create(description: "Challenge 1", status: -1)
    Challenge.create(description: "Challenge 2", status: 1)

    visit admin_profile_path

    expect(page).to have_content("Challenge 1")
    expect(page).not_to have_content("Challenge 2")
  end

  it "allows admin to reject a challenge with a reason" do
    challenge = Challenge.create(description: "Test Challenge", status: -1)

    visit admin_profile_path
    expect(page).to have_content("Test Challenge")

    # Simula il clic sul pulsante "Rifiuta"
    click_button "Rifiuta" # Assicurati che il pulsante abbia il testo corretto

    # Gestisci il prompt per l'inserimento del motivo
    accept_prompt(with: "Not challenging enough") do
      # Qui possiamo confermare il motivo di rifiuto
      click_button "OK"
    end

    # Aspetta che la pagina si ricarichi e che la sfida venga aggiornata
    challenge.reload
    expect(challenge.status).to eq(0)
    expect(challenge.rejection_reason).to eq("Not challenging enough")
  end
end
