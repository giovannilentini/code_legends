class AddUserToChallengeProposals < ActiveRecord::Migration[7.1]
  def change
    add_reference :challenge_proposals, :users, foreign_key: true
  end
end
