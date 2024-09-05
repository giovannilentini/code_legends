class ChallengeRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: 'user_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'friend_id'

  validates :user_id, presence: true
  validates :friend_id, presence: true
end
