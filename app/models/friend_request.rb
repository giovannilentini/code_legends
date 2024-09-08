class FriendRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: 'user_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'friend_id'

  validates :user_id, presence: true
  validates :friend_id, presence: true

  def accept
    Friendship.create(user: sender, friend: receiver)
    destroy # Rimuove la richiesta di amicizia dopo l'accettazione
  end

scope :pending, -> { where(accepted: false) }
scope :accepted, -> { where(accepted: true) }
end
