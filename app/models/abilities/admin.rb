Canard::Abilities.for(:admin) do
    can :manage, :all
    can :approve, Challenge
    can :promote, User
  end
  