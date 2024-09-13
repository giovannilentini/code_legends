class ChallengeProposal < ApplicationRecord
  belongs_to :user
  has_one :challenge
  validates :description, presence: true
  validates :title, presence: true
  validates :test_cases, presence: true

end
