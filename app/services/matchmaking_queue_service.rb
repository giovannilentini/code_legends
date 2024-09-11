class MatchmakingQueueService
  def initialize(user)
    @user = user
    @language = nil
  end

  def add_to_queue(language)
    return if
      MatchmakingQueue.exists?(user: @user, language: language, status: 'waiting') ||
      MatchmakingQueue.exists?(user: @user, status: 'playing')
    @language = language
    user = MatchmakingQueue.exists?(user: @user)
    if user && user.language != language
      user.language = language
    else
      MatchmakingQueue.create(user: @user, status: 'waiting', language: language)
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
    ActiveRecord::Base.transaction do
      MatchmakingQueue.where(user: [@user, opponent.user]).update_all(status: 'playing')
      match = Match.create(player_1_id: @user.id, player_2_id: opponent.user.id, language: @language, status: 'ongoing')
      notify_players(match)
    end

  end

  def notify_players(match)
    # Use ActionCable to notify players
    ActionCable.server.broadcast "matchmaking_#{@user.id}", { action: 'redirect_to_match', match_id: match.id }
    ActionCable.server.broadcast "matchmaking_#{match.player_2.id}", { action: 'redirect_to_match', match_id: match.id }
  end

end