class CreateChallenge < ActiveRecord::Migration[7.1]
  def change
    create_table :challenges do |t|
      t.string :status
      t.references :player_1, foreign_key: { to_table: :players }
      t.references :player_2, foreign_key: { to_table: :players }
      t.timestamps
    end
  end
end
