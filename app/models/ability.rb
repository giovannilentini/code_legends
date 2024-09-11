class Ability
    include CanCan::Ability
  
    def initialize(user)
      # Regole per gli utenti non registrati (guest)
      unless user.nil?
        if user.guest?
          can :create, User
          can :edit, Match
          can :execute_code, Match
          can :surrender, Match
          can :play_now, :all
          can :find_opponent, :all
        else
          if user.admin?
            can :manage, :all
          else
            can :edit, User, id: user.id
            can :update, User, id: user.id
            can :manage, FriendRequest
            can :destroy, Friendship
            can :accept, Friendship
            can :read, ChallengeRequest
            can :create, ChallengeRequest
            can :update, ChallengeRequest, sender: user
            can :accept, ChallengeRequest, receiver: user
            can :reject, ChallengeRequest, receiver: user
            can :create, ChallengeProposal
            can :update, User, id: user.id
            can :read, User
            can :edit, Match
            can :execute_code, Match
            can :surrender, Match
            can :play_now, :all
            can :find_opponent, :all
            can :create, ChatMessage
            can :cancel, MatchmakingQueue
            can :create, ChallengeProposal
            can :read, ChallengeProposal
          end
        end

      end


    end
  end
  
  