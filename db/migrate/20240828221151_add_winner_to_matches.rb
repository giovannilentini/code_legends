class AddWinnerToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :winner, :integer
  end
end
