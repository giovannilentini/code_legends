class CreateTestCases < ActiveRecord::Migration[7.1]
  def change
    create_table :test_cases do |t|
      t.string :input_example
      t.string :input_type
      t.string :output_type
      t.string :expected_output
      t.references :challenge
      t.timestamps
    end
  end
end
