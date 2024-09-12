class User < ApplicationRecord
    has_secure_password

    # Validazioni
    validates :email, presence: true, uniqueness: true, unless: :guest?
    # Associazioni
    has_many :challenge_proposals
    has_one_attached :profile_image
  
    has_many :sent_friend_requests, class_name: 'FriendRequest', foreign_key: :user_id, dependent: :destroy
    has_many :received_friend_requests, class_name: 'FriendRequest', foreign_key: :friend_id, dependent: :destroy
  
    has_many :friendships, dependent: :destroy
    has_many :friends, through: :friendships, dependent: :destroy
  
    has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy
    has_many :inverse_friends, through: :inverse_friendships, source: :user, dependent: :destroy

    has_many :sent_challenge_requests, class_name: 'ChallengeRequest', foreign_key: 'user_id',dependent: :destroy
    has_many :received_challenge_requests, class_name: 'ChallengeRequest', foreign_key: 'friend_id',dependent: :destroy

    validate :must_have_auth0_id_or_password


    def guest?
      guest
    end
  
    def admin?
      is_admin
    end

    def has_password?
        password_digest.present?
    end
    def has_auth0?
        auth0_id
    end

    # Metodo per ottenere la miniatura dell'immagine del profilo
    def profile_image_thumbnail
      profile_image.variant(resize_to_fill: [200, 200]).processed
    end

    private

    def must_have_auth0_id_or_password
        unless guest?
            if auth0_id.blank? && password_digest.blank?
                errors.add(:base, "Either auth0_id or password_digest must be present")
            end
        end
    end

end
  