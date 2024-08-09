class CreateTestCases < ActiveRecord::Migration[7.1]
  def change
    create_table :test_cases do |t|
      t.string :input_example
      t.string :expected_output
      t.integer :challenge_id
      t.timestamps
    end
  end
end
