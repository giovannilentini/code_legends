# frozen_string_literal: true

class Challenge < ApplicationRecord
  belongs_to :challenge_proposal, optional: true
  validates :title, presence: true
  validates :description, presence: true
  validates :difficulty, presence: true
  validates :language, presence: true
end