class AddTimerExpiresAtToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :timer_expires_at, :datetime
  end
end
