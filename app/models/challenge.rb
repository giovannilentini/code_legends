# frozen_string_literal: true

class Challenge < ApplicationRecord

  has_many :test_cases, dependent: :destroy
  belongs_to :user
  belongs_to :challenge_proposal

  accepts_nested_attributes_for :test_cases, allow_destroy: true

  validates :title, presence: true

  validates :description, presence: true
  validates :status, inclusion: { in: [0, 1], message: "%{value} non è un valore valido" }
  validates :rejection_reason, presence: true, if: -> { status == 0 }

  scope :accepted, -> { where(status: 1) }
  scope :rejected, -> { where(status: 0) }
end
