class CreateMatchmakingQueues < ActiveRecord::Migration[7.1]
  def change
    create_table :matchmaking_queues do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.string :language
      t.timestamps
    end
  end
end
