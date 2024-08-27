class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.references :match, null: false, foreign_key: true
      t.string :uuid, null: false
      t.timestamps
    end
  end
end

