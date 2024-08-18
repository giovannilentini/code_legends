class AddWaitingToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :waiting, :boolean
  end
end
