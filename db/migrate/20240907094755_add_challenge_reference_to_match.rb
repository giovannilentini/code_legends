class AddChallengeReferenceToMatch < ActiveRecord::Migration[7.1]
  def change
    add_reference :matches, :challenge
  end
end
