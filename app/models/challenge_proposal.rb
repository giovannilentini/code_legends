class ChallengeProposal < ApplicationRecord
  belongs_to :user
  has_one :challenge
  validates :description, presence: true
  validates :title, presence: true

  serialize :test_cases, coder: JSON
end
