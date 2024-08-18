class Challenge < ApplicationRecord
  STATUS_INACTIVE = 0
  STATUS_ACTIVE = 1

  has_many :test_cases, dependent: :destroy

  accepts_nested_attributes_for :test_cases, allow_destroy: true

  validates :description, presence: true
end
