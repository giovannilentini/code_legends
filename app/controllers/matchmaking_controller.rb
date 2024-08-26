class MatchmakingController < ApplicationController
  def play_now
    @languages = ['Python3', 'Java', 'Cpp']
    @selected_language = params[:language].presence || 'python3'
    session[:selected_language] = @selected_language
  end

  def find_opponent

    @selected_language = session[:selected_language]
    player = Player.find_or_create_by(id: session[:player_id])
    if player
      MatchmakingQueueService.add(player, @selected_language)

    end

  end

  def challenge_friend
    player = Player.find_or_create_by(name: session[:player_name])
    friend = Player.find(params[:friend_id])
    challenge = Match.create(player_1: player, player_2: friend, status: 'pending')
    room = Room.create(challenge: challenge, uuid: SecureRandom.uuid)

    redirect_to challenge_path(room.uuid)
  end
  def challenge
    @room = Room.find_by(uuid: params[:uuid])
    @challenge = @room.challenge
  end
end
