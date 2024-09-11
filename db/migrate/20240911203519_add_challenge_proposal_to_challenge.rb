class AddChallengeProposalToChallenge < ActiveRecord::Migration[7.1]
  def change
    add_reference :challenges, :challenge_proposal, foreign_key: true
  end
end
