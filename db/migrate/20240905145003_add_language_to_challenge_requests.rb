class AddLanguageToChallengeRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :challenge_requests, :language, :string
  end
end
