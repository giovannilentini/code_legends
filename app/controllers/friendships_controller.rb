class FriendshipsController < ApplicationController
  def create
      friend = User.find(params[:id])

      if friend.nil?
        redirect_to root_path, alert: 'Utente non trovato.'
      elsif friend == current_user
        redirect_to root_path, alert: 'Non puoi aggiungere te stesso come amico.'
      elsif current_user.friends.include?(friend)
        redirect_to user_path(friend), alert: 'Sei già amico di questo utente.'
      else
      current_user.friends << friend unless current_user.friends.include?(friend) || friend == current_user
      redirect_to user_path(friend), notice: 'Amico aggiunto con successo!'
      end
    end
end
