class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :match

  validate :guest
  validate :message_content_not_empty
  validate :chars_limit

  def guest
    if user.guest?
      errors.add(:base, "User must be registered!")
    end
  end

  def message_content_not_empty
    if content == ""
      errors.add(:content, "Message must be not empty!")
    end
  end

  def chars_limit
    if content.length > 500
      errors.add(:content, "Message must is too long!(max. 500)")
    end
  end
end
