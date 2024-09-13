class AddNullToChallengeProposal < ActiveRecord::Migration[7.1]
  def change
    change_column_null :challenges, :challenge_proposal_id, true
  end
end
