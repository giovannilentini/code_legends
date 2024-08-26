class Match < ApplicationRecord

  belongs_to :player_1, class_name: 'User', foreign_key: 'player_1_id'
  belongs_to :player_2, class_name: 'User', foreign_key: 'player_2_id'
  validate :players_must_be_different

  private


  def players_must_be_different
    if player_1_id == player_2_id
      errors.add(:player_2, 'must be different from Player 1')
    end
  end
end
