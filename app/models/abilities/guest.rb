Canard::Abilities.for(:guest) do
    can :play, Game
    can :create, User
    can :create, ChallengeRequest
  end
  