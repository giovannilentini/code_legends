class MatchmakingQueueService
    @queue = {}
  
    def self.add(user, language)
      @queue[language] ||= []

      unless @queue[language].include? user
        @queue[language] << user
        match_users(language) if @queue[language].size >= 2
      end
    end
  
    def self.remove(user, language)
      @queue[language].delete(user)
    end
  
    def self.match_users(language)
      users = @queue[language].shift(2)
      if users.size == 2
        challenge = Challenge.create(player_1: users[0], player_2: users[1], language: language)
        ActionCable.server.broadcast("matchmaking_#{language}", { challenge_id: challenge.id, player_1: users[0], player_2: users[1] })
        users.each do |user| remove(user, language) end
      end
    end

    def self.print_queue
      p @queue
    end
  end