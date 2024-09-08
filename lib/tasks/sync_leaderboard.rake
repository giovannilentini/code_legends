namespace :leaderboard do
  desc "Sync leaderboard from SQLite to Redis"
  task sync_to_redis: :environment do
    User.find_each do |user|
      # Add each user to Redis leaderboard with their rank (or score)
      LeaderboardService.update_score(user.id, 0)
    end
    puts "Leaderboard synced to Redis!"
  end
end