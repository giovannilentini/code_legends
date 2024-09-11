class AddChallengeProposalsToUser < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :challenge_proposals, foreign_key: true
  end
end
