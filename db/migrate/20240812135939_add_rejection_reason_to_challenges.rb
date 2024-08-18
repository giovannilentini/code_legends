class AddRejectionReasonToChallenges < ActiveRecord::Migration[7.1]
  def change
    add_column :challenges, :rejection_reason, :string
  end
end
