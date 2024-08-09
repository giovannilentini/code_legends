class Challenge < ApplicationRecord
  has_many :test_cases, dependent: :destroy

  accepts_nested_attributes_for :test_cases, allow_destroy: true

  validates :description, presence: true
end
