class CreateMatch < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.string :language
      t.string :status
      t.integer :winner_id
      t.integer :player_1_id
      t.integer :player_2_id
      t.timestamps
    end
  end
end
