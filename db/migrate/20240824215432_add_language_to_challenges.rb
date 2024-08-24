class AddLanguageToChallenges < ActiveRecord::Migration[7.1]
  def change
    add_column :challenges, :language, :string
  end
end
