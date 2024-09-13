# frozen_string_literal: true

class Challenge < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
end
