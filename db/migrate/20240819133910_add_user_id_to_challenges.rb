class AddUserIdToChallenges < ActiveRecord::Migration[7.1]
  def change
    add_column :challenges, :user_id, :integer
    add_index :challenges, :user_id
  end
end
