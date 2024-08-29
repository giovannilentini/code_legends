class CreateChallenges < ActiveRecord::Migration[7.1]
  def change
    create_table :challenges do |t|
      t.references :user, null: false, foreign_key: true
      t.string :description
      t.integer :status, default: -1
      t.string :rejection_reason, default: nil
      t.timestamps
    end
  end
end
