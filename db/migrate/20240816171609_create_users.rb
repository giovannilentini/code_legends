class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :auth0_id
      t.references :challenges, foreign_key: true
      t.boolean :is_admin, default: false
      t.timestamps
    end
  end
end
