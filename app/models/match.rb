class Match < ApplicationRecord

  belongs_to :player_1, class_name: 'User', foreign_key: 'player_1_id'
  belongs_to :player_2, class_name: 'User', foreign_key: 'player_2_id'
  belongs_to :challenge
  validate :players_must_be_different
  validates :player_1, presence: true
  validates :player_2, presence: true
  validates :challenge, presence: true
  validate :players_must_be_different
  
  has_many :chat_messages, dependent: :destroy

  private

  def players_must_be_different
    if player_1 == player_2
      errors.add(:player_2, 'must be different from Player 1')
    end
  end
end
