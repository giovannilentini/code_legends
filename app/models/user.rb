class User < ApplicationRecord
    before_validation :generate_guest_username, if: :guest?
    validates :username, presence: true, uniqueness: true, unless: :registered?
    validates :email, presence: true, uniqueness: true, unless: :guest?

    def guest?
        self.is_a?(Guest)
    end

    def registered?
        self.is_a?(RegisteredUser)
    end

    def generate_guest_username
        if guest? && username.blank?
            self.username = "Guest_#{SecureRandom.random_number(10000)}"
        end
    end

end
  