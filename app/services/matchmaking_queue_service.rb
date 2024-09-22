class MatchmakingQueueService

  REDIS_QUEUE_KEY = "matchmaking_queue"
  REDIS_PLAYER_HASH = "matchmaking_queue_players"

  def self.add_to_queue(user, language)

    player_key = "#{user.id}:#{language}"
    return if player_exists?(user.id, language) # Skip if player already in queue

    current_time = Time.now.to_f # Timestamp as the score
    value = { player_id: user.id, language: language}.to_json

    # Add to sorted set and player hash
    $redis.zadd(REDIS_QUEUE_KEY, current_time, value)
    $redis.hset(REDIS_PLAYER_HASH, player_key, 'waiting')
    MatchmakingQueueService.find_opponent
  end

  def self.player_exists?(player_id, language)
    player_key = "#{player_id}:#{language}"
    $redis.hexists(REDIS_PLAYER_HASH, player_key)
  end

  def self.remove_player(player, language)
    player_key = "#{player.id}:#{language}"

    # Check if the player exists in the hash
    if $redis.hexists(REDIS_PLAYER_HASH, player_key)
      # Create the expected JSON value based on player details
      expected_value = { player_id: player.id, language: language }.to_json

      # Remove the player from the sorted set using the expected JSON value
      $redis.zrem(REDIS_QUEUE_KEY, expected_value)

      # Remove the player from the hash
      $redis.hdel(REDIS_PLAYER_HASH, player_key)

      puts "Player #{player.id} has been removed from the matchmaking queue."
    else
      puts "Player #{player.id} is not in the matchmaking queue."
    end
  end

  def self.dequeue
    value = $redis.zrange(REDIS_QUEUE_KEY, 0, 0).first
    return nil unless value

    # Parse and remove from both sorted set and hash
    data = JSON.parse(value, symbolize_names: true)
    player_key = "#{data[:player_id]}:#{data[:language]}"

    $redis.zrem(REDIS_QUEUE_KEY, value)
    $redis.hdel(REDIS_PLAYER_HASH, player_key)

    data
  end

  private
  def self.find_opponent
    if $redis.zcard(REDIS_QUEUE_KEY) >= 2
      # Dequeue two players
      player_one = MatchmakingQueueService.dequeue
      player_two = MatchmakingQueueService.dequeue



      if player_one && player_two && player_one[:player_id] != player_two[:player_id] && player_one[:language] == player_two[:language]
        # Create a match between player_one and player_two
        MatchmakingQueueService.create_match(player_one[:player_id], player_two[:player_id], player_one[:language])
      else
        # "Not enough players to create a match."
      end
    else
      # "Not enough players in the queue."
    end
  end

  def self.create_match(player1, player2, language)

    challenge_ids = Challenge.where(language: language).pluck(:id)


    if challenge_ids.empty?
      return
    end

    challenge_id = challenge_ids.sample

    challenge = Challenge.find_by(id: challenge_id)


    if challenge.nil?
      return
    end

    # Create the match with the selected challenge
    match = Match.create!(player_1_id: player1, player_2_id: player2, language: language, status: 'ongoing', challenge_id: challenge.id)

    # Notify players
    MatchmakingQueueService.notify_players(match)
  end


  def self.notify_players(match)
    # Use ActionCable to notify players
    ActionCable.server.broadcast "matchmaking_#{match.player_1_id}", { action: 'redirect_to_match', match_id: match.id }
    ActionCable.server.broadcast "matchmaking_#{match.player_2_id}", { action: 'redirect_to_match', match_id: match.id }
  end

end