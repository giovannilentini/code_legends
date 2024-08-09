class DropTestCasesAndChallenges < ActiveRecord::Migration[6.0]
  def up
    drop_table :test_cases if ActiveRecord::Base.connection.table_exists?(:test_cases)
    drop_table :challenges if ActiveRecord::Base.connection.table_exists?(:challenges)
  end

end
