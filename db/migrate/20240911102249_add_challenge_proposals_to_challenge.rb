class AddChallengeProposalsToChallenge < ActiveRecord::Migration[7.1]
  def change
    add_reference :challenges, :challenge_proposals, null: false, foreign_key: true
  end
end
