class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :match
end
