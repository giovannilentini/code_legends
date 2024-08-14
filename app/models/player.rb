class Player < ApplicationRecord
  has_many :challenges_as_player1, class_name: 'Challenge', foreign_key: 'player_1_id'
  has_many :challenges_as_player2, class_name: 'Challenge', foreign_key: 'player_2_id'
  attribute :waiting, :boolean, default: false
end

  