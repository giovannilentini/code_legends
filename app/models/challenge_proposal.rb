class ChallengeProposal < ApplicationRecord

  has_many :test_cases, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :test_cases, allow_destroy: true

  validates :description, presence: true

  scope :accepted, -> { where(status: 1) }
  scope :rejected, -> { where(status: 0) }
end
