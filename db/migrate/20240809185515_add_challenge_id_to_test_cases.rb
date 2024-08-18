class AddChallengeIdToTestCases < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :test_cases, :challenges, column: :challenge_id
    add_index :test_cases, :challenge_id
  end
end
