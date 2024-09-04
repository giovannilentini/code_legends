class CreateChallenges < ActiveRecord::Migration[7.1]
  def change
    create_table :challenges do |t|
      t.references :code_templates, foreign_key: true
      t.string  :title
      t.string :description
      t.string :difficulty
      t.timestamps
    end
  end
end
