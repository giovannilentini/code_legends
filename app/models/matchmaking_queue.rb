class MatchmakingQueue
    @queue = {}
  
    def self.add(user, language)
      @queue[language] ||= []
      @queue[language] << user
      match_users(language) if @queue[language].size >= 2
    end
  
    def self.remove(user)
      @queue.each do |language, users|
        users.delete(user)
      end
    end
  
    def self.match_users(language)
      users = @queue[language].shift(2)
      if users.size == 2
        challenge = Challenge.create(player_1: users[0], player_2: users[1], language: language)
        ActionCable.server.broadcast("matchmaking_#{language}", {
          type: 'MATCH_FOUND',
          challenge_url: Rails.application.routes.url_helpers.challenge_path(challenge.id)
        })
      end
    end
  end
  
  