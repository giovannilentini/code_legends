class MatchmakingQueueController < ApplicationController

  before_action :set_languages
  def play_now


  end

  def find_opponent
    player = User.find_by(id: session[:user_id])
    if player
      MatchmakingQueueService.new(player).add_to_queue(@selected_language)
    end
  end

  def challenge_friend
    player = Player.find_or_create_by(name: session[:player_name])
    friend = Player.find(params[:friend_id])
    challenge = Match.create(player_1: player, player_2: friend, status: 'pending')
    room = Room.create(challenge: challenge, uuid: SecureRandom.uuid)

    redirect_to challenge_path(room.uuid)
  end

  private
  def set_languages
    @languages = ['Python3', 'Java', 'Cpp']
    @selected_language = params[:language].presence || 'python3'
  end

end
