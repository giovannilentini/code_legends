class MatchmakingController < ApplicationController
  before_action :set_player_name

  def play_now
    @languages = ["Ruby", "Python", "JavaScript"]
  end

  def challenge_friend
    player = Player.find_or_create_by(name: session[:player_name])
    friend = Player.find(params[:friend_id])
    challenge = Challenge.create(player_1: player, player_2: friend, status: 'pending')
    room = Room.create(challenge: challenge, uuid: SecureRandom.uuid)

    redirect_to challenge_path(room.uuid)
  end

  def find_opponent
    player = Player.find_or_create_by(name: session[:player_name])
    opponent = Player.where.not(id: player.id).sample
    challenge = Challenge.create(player_1: player, player_2: opponent, status: 'pending')
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
