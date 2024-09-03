class User < ApplicationRecord
    # Validazioni
    validates :email, presence: true, uniqueness: true
    validates :auth0_id, presence: true, uniqueness: true

    # Associazioni per le challenge
    has_many :challenges

    # Associazione per l'immagine del profilo
    has_one_attached :profile_image

    # Associazioni per le richieste di amicizia
    has_many :sent_friend_requests, class_name: 'FriendRequest', foreign_key: :user_id, dependent: :destroy
    has_many :received_friend_requests, class_name: 'FriendRequest', foreign_key: :friend_id, dependent: :destroy

    # Associazioni per le amicizie
    has_many :friendships, dependent: :destroy
    has_many :friends, through: :friendships

    # Inverse friendships
    has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy
    has_many :inverse_friends, through: :inverse_friendships, source: :user

    has_many :chat_messages, dependent: :destroy

    # Metodo per verificare se l'utente è admin
    def admin?
        is_admin
    end

    # Metodo per ottenere la miniatura dell'immagine del profilo
    def profile_image_thumbnail
        profile_image.variant(resize_to_fill: [200, 200]).processed
    end
end
