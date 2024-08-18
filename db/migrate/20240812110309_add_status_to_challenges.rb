class AddStatusToChallenges < ActiveRecord::Migration[7.1]
  def change
    add_column :challenges, :status, :integer, default: -1
  end
end
