class Ability
    include CanCan::Ability
  
    def initialize(user)
      # Regole per gli utenti non registrati (guest)
      unless user.nil?
        if user.guest?
          can :create, User
          can :show, Match
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
            can :create, ChallengeRequest
            can :update, ChallengeRequest, sender_id: user.id
            can :accept, ChallengeRequest, receiver_id: user.id
            can :reject, ChallengeRequest
            can :create, ChallengeProposal
            can :update, User, id: user.id
            can :read, User
            can :show, Match
            can :execute_code, Match
            can :surrender, Match
            can :play_now, :all
            can :find_opponent, :all
            can :create, ChatMessage
            can :cancel, MatchmakingQueue
          end
        end

      end


    end
  end
  
  