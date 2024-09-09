class Ability
    include CanCan::Ability
  
    def initialize(user)
      user ||= User.new
      # User authorizations
      unless user.guest?
        # Guest authorization Rules
        can :read, :leaderboard
        can :read, :play_now
        can :play_now, :all
        can :read, Match do |match|
          # Allow access if the current user's id matches either player in the match
          match.player_1 == user || match.player_2 == user
        end
        if user.admin?
          can :manage, :all
        end
        can :update, User
        can :read, User
        can :create, Friendship
        can :create, FriendRequest
        can :update, FriendRequest
        can :destroy, FriendRequest
        can :accept, FriendRequest, receiver_id: user.id
        can :reject, FriendRequest, receiver_id: user.idp
      end
    end
  end
  
  