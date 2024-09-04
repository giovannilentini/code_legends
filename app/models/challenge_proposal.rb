class ChallengeProposal < ApplicationRecord
  belongs_to :user
  validates :description, presence: true
  validates :title, presence: true

  serialize :test_cases, coder: JSON
end
