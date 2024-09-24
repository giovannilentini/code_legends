class RegisteredUser < User
  has_secure_password

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, if: :new_record? # Ensure password is present for new records

  # Associations
  has_many :challenge_proposals, dependent: :nullify
  has_one_attached :profile_image, dependent: :destroy

  # Friendships
  has_many :sent_friend_requests, class_name: 'FriendRequest', foreign_key: :user_id, dependent: :destroy
  has_many :received_friend_requests, class_name: 'FriendRequest', foreign_key: :friend_id, dependent: :destroy

  has_many :sent_friendships, class_name: 'Friendship', foreign_key: :user_id, dependent: :destroy
  has_many :received_friendships, class_name: 'Friendship', foreign_key: :friend_id, dependent: :destroy
  has_many :friends, through: :sent_friendships, source: :friend

  has_many :sent_challenge_requests, class_name: 'ChallengeRequest', foreign_key: 'user_id', dependent: :destroy
  has_many :received_challenge_requests, class_name: 'ChallengeRequest', foreign_key: 'friend_id', dependent: :destroy

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

  # Generates a reset token and sets its expiration
  def generate_password_reset_token!
    self.reset_token = SecureRandom.urlsafe_base64
    self.reset_sent_at = Time.current
    update_columns(reset_token: reset_token, reset_sent_at: Time.zone.now)
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64.to_s
    update_columns(confirmation_token: confirmation_token)
  end

  # Checks if the reset token is still valid
  def password_reset_token_valid?
    self.reset_sent_at > 2.hours.ago && self.reset_token != nil
  end

  # Clears the reset token after use
  def clear_password_reset_token!
    update_columns(reset_token: nil, reset_sent_at: nil)
  end
end