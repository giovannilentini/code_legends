class Ability
    include CanCan::Ability
  
    def initialize(user)
      # Regole per gli utenti non registrati (guest)
      can :create, User
      can :index,        ChallengeRequest
      can :create,       ChallengeRequest
      can :accept,       ChallengeRequest, receiver_id: user.id
      can :update,       ChallengeRequest, sender_id: user.id

      can :show,         Match
      can :execute_code, Match
      can :surrender,    Match

      can :play_now,      MatchmakingQueueController
      can :find_opponent, MatchmakingQueueController
      can :cancel,        MatchmakingQueueController
      can :set_languages, MatchmakingQueueController


      cannot :show,    ChallengeProposal
      cannot :new,     ChallengeProposal
      cannot :create,  ChallengeProposal
      cannot :reject,  ChallengeProposal
      cannot :destroy, ChallengeProposal
      cannot :create,  FriendRequest
      cannot :accept,  FriendRequest
      cannot :reject,  FriendRequest
      cannot :create,  Friendship
      cannot :new,     Challenge
      cannot :show,    Challenge
      cannot :create,  Challenge
      cannot :update_status, Challenge
      cannot :create, ChatMessage
      cannot :user_profile, User
      cannot :admin_profile, User
      cannot :promote_to_admin, User
      cannot :read,  User 
      cannot :edit,  User, id: user.id
      cannot :update, User, id: user.id 
      

  
      # Regole per gli utenti registrati
      if user.present?
        if user.admin?
          can :manage, :all
          can :approve, Challenge
          can :promote_to_admin, User
          can :update_status, Challenge
          can :reject,  ChallengeProposal
          can :destroy, ChallengeProposal
          can :admin_profile, User, id: user.id
          can :promote_to_admin, User

        else
          can :edit, User, id: user.id
          can :update, User, id: user.id 
          can :create,   FriendRequest
          can :accept,   FriendRequest, receiver_id: user.id
          can :reject,   FriendRequest, receiver_id: user.id
          can :manage,   FriendRequest, receiver_id: user.id
          can :destroy,  Friendship, user_id: user.id
          can :accept,   Friendship
          can :manage,   Challenge, user_id: user.id
          can :accept,   Challenge
          can :reject,   Challenge
          can :create,   Challenge
          can :update,   Challenge, user_id: user.id
          can :create,   ChallengeRequest
          can :update,   ChallengeRequest, sender_id: user.id
          can :accept,   ChallengeRequest, receiver_id: user.id
          can :reject,   ChallengeRequest
          can :create,   ChallengeProposal
          can :edit,     User, id: user.id
          can :read,     User, id: user.id
          can :show,     User, id: user.id
          can :show,          Match
          can :execute_code,  Match
          can :surrender,     Match
          can :play_now,      Match
          can :set_languages, MatchmakingQueueController
          can :play_now,      MatchmakingQueueController
          can :find_opponent, MatchmakingQueueController
          can :cancel,        MatchmakingQueueController
          can :create,        ChatMessage
          can :user_profile, User, id: user.id
          can :play_now,      MatchmakingQueueController
          can :find_opponent, MatchmakingQueueController
          can :cancel,        MatchmakingQueueController
          

          cannot :admin_profile, User
          cannot :promote_to_admin, User
          cannot :update_status, Challenge

        end
      end
  

    end
  end
  
  