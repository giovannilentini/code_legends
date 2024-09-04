class CreateTestCases < ActiveRecord::Migration[7.1]
  def change
    create_table :test_cases do |t|
      t.references :challenge, null: false, foreign_key: true
      t.text :input_data
      t.text :output_data
      t.timestamps
    end
  end
end
