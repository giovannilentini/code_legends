class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    validates :auth0_id, presence: true, uniqueness: true
    has_many :challenges
    has_one_attached :profile_image

    def admin?
      is_admin
    end

    def profile_image_thumbnail
      profile_image.variant(resize_to_fill: [200, 200]).processed
    end
  end
  