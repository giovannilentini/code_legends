# frozen_string_literal: true

class Challenge < ApplicationRecord
  belongs_to :challenge_proposal
  validates :title, presence: true

  validates :description, presence: true
end
