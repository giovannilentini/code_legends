class LeaderboardService
  LEADERBOARD_KEY = "leaderboard"

  # Adds or updates the user's score in Redis and updates rank in SQLite
  def self.update_score(user_id, rank_gain)

    user = User.find(user_id)
    new_rank = [user.rank+rank_gain, 0].max
    user.update(rank: new_rank)

    # Update score in Redis
    $redis.zadd(LEADERBOARD_KEY, new_rank, "user_#{user_id}")
  end

  # Gets the top N registered_users from the leaderboard (using Redis)
  def self.top_users(limit = 10)
    $redis.zrange(LEADERBOARD_KEY, 0, limit-1, rev: true, with_scores: true)
  end

  def self.flushall
    $redis.flushall
  end

end