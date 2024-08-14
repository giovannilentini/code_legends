class CreateChallenges < ActiveRecord::Migration[7.1]
  def change
    create_table :challenges do |t|
      t.integer :player_1_id
      t.integer :player_2_id
      t.string :status

      t.timestamps
    end
  end
end
