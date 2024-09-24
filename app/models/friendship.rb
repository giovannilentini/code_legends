class Friendship < ApplicationRecord
  belongs_to :user, class_name: 'RegisteredUser'
  belongs_to :friend, class_name: 'RegisteredUser'

  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :user_id, uniqueness: { scope: :friend_id }
  validate :not_self

  private

  def not_self
    errors.add(:friend_id, "cannot be the same as user") if user_id == friend_id
  end
  
end
