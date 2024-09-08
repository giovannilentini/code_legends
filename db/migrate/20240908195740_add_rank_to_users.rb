class AddRankToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :rank, :integer, default: 0
  end
end
