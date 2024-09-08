Canard::Abilities.for(:user) do
    can :play, Game
    can :create, FriendRequest  # Permetti la creazione delle richieste di amicizia
    can :accept, FriendRequest, receiver_id: user.id  # Permetti di accettare solo le richieste che l'utente ha ricevuto
    can :destroy, Friendship, user_id: user.id  # Permetti di distruggere le amicizie dove l'utente è coinvolto
    can :manage, Challenge, user_id: user.id
    can :create, ChallengeRequest
    can :update, ChallengeRequest, sender_id: user.id
    can :accept, ChallengeRequest, receiver_id: user.id
    can :edit, User, id: user.id
    can :read, User
  end




  