class MatchmakingController < ApplicationController
  before_action :set_player_name

  def play_now
    @languages = ['Python3', 'Java', 'Cpp']
    @selected_language = params[:language].presence || 'python3'
    session[:selected_language] = @selected_language
  end



  def find_opponent

    @selected_language = session[:selected_language]
    player = Player.find_or_create_by(name: session[:player_name])
    if player
      MatchmakingQueueService.add(player, @selected_language)
    end

  end

  def challenge_friend
    player = Player.find_or_create_by(name: session[:player_name])
    friend = Player.find(params[:friend_id])
    challenge = Challenge.create(player_1: player, player_2: friend, status: 'pending')
    room = Room.create(challenge: challenge, uuid: SecureRandom.uuid)

    redirect_to challenge_path(room.uuid)
  end
  def challenge
    @room = Room.find_by(uuid: params[:uuid])
    @challenge = @room.challenge
  end

  private

  def set_player_name
    session[:player_name] ||= "Player_#{SecureRandom.hex(4)}"
  end
end
