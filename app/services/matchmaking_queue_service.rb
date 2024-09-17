class MatchmakingQueueService
  def initialize(user)
    @user = user
    @language = nil
  end

  def add_to_queue(language)

    # User already in queue for the language or
    # User already in game
    return if
      MatchmakingQueue.exists?(user: @user, language: language, status: 'waiting') ||
      MatchmakingQueue.exists?(user: @user, status: 'playing')
    @language = language


    user = MatchmakingQueue.exists?(user: @user)
    # User already in queue but wants to change language
    if user && user.language != language
      user.language = language
    else
      MatchmakingQueue.create!(user: @user, status: 'waiting', language: language)
    end
    find_opponent
  end

  def self.remove_from_queue(user)
    MatchmakingQueue.where(user: user).destroy_all
  end

  private
  def find_opponent
    opponent = MatchmakingQueue.waiting.where.not(user: @user).order(updated_at: :asc).first
    if opponent
      create_match(opponent)
    else
      # The user remains in the queue waiting
    end
  end

  def create_match(opponent)
    # Update matchmaking queue status
    MatchmakingQueue.where(user: [@user, opponent.user]).update_all(status: 'playing')

    # Fetch challenge IDs with the specified language
    challenge_ids = Challenge.where(language: @language).pluck(:id)

    # Handle case where no challenges are found
    if challenge_ids.empty?
      return # or handle this case as needed
    end

    # Pick a random challenge ID
    challenge_id = challenge_ids.sample

    # Find the challenge using the randomly selected ID
    challenge = Challenge.find_by(id: challenge_id)

    # Ensure the challenge was found
    if challenge.nil?
      Rails.logger.warn "Challenge with ID #{challenge_id} not found"
      return # or handle this case as needed
    end

    # Create the match with the selected challenge
    match = Match.create(player_1_id: @user.id, player_2_id: opponent.user.id, language: @language, status: 'ongoing', challenge_id: challenge.id)

    # Notify players
    notify_players(match)
  end


  def notify_players(match)
    # Use ActionCable to notify players
    ActionCable.server.broadcast "matchmaking_#{@user.id}", { action: 'redirect_to_match', match_id: match.id }
    ActionCable.server.broadcast "matchmaking_#{match.player_2_id}", { action: 'redirect_to_match', match_id: match.id }
  end

end