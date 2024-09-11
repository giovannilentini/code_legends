class CreateChallengeProposals < ActiveRecord::Migration[7.1]
  def change
    create_table :challenge_proposals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :test_cases, null: false
      t.string :description, null: false
      t.string :status, default: "pending"
      t.string :rejection_reason, default: nil
      t.string :language, default: nil
      t.timestamps
    end
  end
end
