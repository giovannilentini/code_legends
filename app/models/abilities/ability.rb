class Ability
    include CanCan::Ability
  
    def initialize(user)
      # Regole per gli utenti non registrati (guest)
      can :play, Game
      can :create, User
      can :create, ChallengeRequest
      can :update, ChallengeRequest, sender_id: user.id
      can :accept, ChallengeRequest, receiver_id: user.id
      can :play_now, Match
      can :find_opponent, MatchmakingQueueController
      can :cancel, MatchmakingQueueController
  
      # Regole per gli utenti registrati
      if user.present?
        if user.admin?
          can :manage, :all
          can :approve, Challenge
          can :promote, User
          can :update_status, Challenge
          can :reject, ChallengeProposal
          can :destroy, ChallengeProposal
          can :
        else
          can :play, Game
          can :create, FriendRequest
          can :accept, FriendRequest, receiver_id: user.id
          can :reject, FriendRequest, receiver_id: user.id
          can :destroy, Friendship, user_id: user.id
          can :accept, Friendship
          can :manage, Challenge, user_id: user.id
          can :accept, Challenge
          cap :reject, Challenge
          can :create, Challenge
          can :update, Challenge, user_id: user.id
          can :create, ChallengeRequest
          can :update, ChallengeRequest, sender_id: user.id
          can :accept, ChallengeRequest, receiver_id: user.id
          can :reject, ChallengeRequest
          can :create, ChallengeProposal
          can :edit, User, id: user.id
          can :read, User
          can :manage, FriendRequest, receiver_id: user.id
          can :play_now, Match
          can :find_opponent, MatchmakingQueueController
          can :cancel, MatchmakingQueueController

  
          can :create, ChatMessage
        end
      end
  
      # Regole per tutti gli utenti, inclusi guest

    end
  end
  
  