class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    validates :auth0_id, presence: true, uniqueness: true
    has_many :challenges

    def admin?
      is_admin
    end
  end
  