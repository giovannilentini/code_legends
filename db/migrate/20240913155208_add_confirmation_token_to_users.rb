class AddConfirmationTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :email_confirmed_at, :datetime
  end
end
