require 'rails_helper'

RSpec.describe "UserProfile", type: :system do
  before do


    # Crea sfide accettate e rifiutate
    Challenge.create(description: "Accepted Challenge", status: 1)
    Challenge.create(description: "Rejected Challenge", status: 0, rejection_reason: "Too simple")
  end

  it "shows accepted challenges" do
    visit profile_path  # Usa il percorso corretto

    # Verifica che la challenge accettata sia visibile
    expect(page).to have_content("Accepted Challenge")
  end

  it "shows rejected challenges with reasons" do
    visit profile_path  # Usa il percorso corretto

    # Verifica che la challenge rifiutata sia visibile
    expect(page).to have_content("Rejected Challenge")
    expect(page).to have_content("Too simple")
  end
end
