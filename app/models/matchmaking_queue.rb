class MatchmakingQueue < ApplicationRecord
  belongs_to :user
  scope :waiting, -> { where(status: "waiting") }
  scope :playing, -> { where(status: "playing") }
  validates :user, presence: true
  validates :language, presence: true
  validates :status, presence: true
end
