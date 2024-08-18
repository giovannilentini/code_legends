class AddRoomToChallenges < ActiveRecord::Migration[7.1]
  def change
    add_column :challenges, :room, :string
  end
end
