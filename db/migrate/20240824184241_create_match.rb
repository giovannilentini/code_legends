class CreateMatch < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.string :language
      t.string :status
      t.references :winner, foreign_key: { to_table: :users }
      t.references :player_1, foreign_key: { to_table: :users }
      t.references :player_2, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
