class CreateChallenges < ActiveRecord::Migration[7.1]
  def change
    create_table :challenges do |t|
      t.string :code_template
      t.string :test_template
      t.string :language
      t.string :title
      t.string :description
      t.string :difficulty
      t.timestamps
    end
  end
end
