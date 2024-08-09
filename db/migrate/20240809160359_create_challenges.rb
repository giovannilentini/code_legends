class CreateChallenges < ActiveRecord::Migration[7.1]
  def change
    create_table :challenges do |t|
      t.text :description
      t.text :input_example
      t.text :expected_output

      t.timestamps
    end
  end
end
