class FriendshipsController < ApplicationController
  before_action :authenticate_user! # Solo utenti autenticati possono gestire amicizie
  def create
    friend = User.find(params[:id])
    
    if friend.nil?
      redirect_to root_path, alert: 'Utente non trovato.'
    elsif friend == current_user
      redirect_to root_path, alert: 'Non puoi aggiungere te stesso come amico.'
    elsif current_user.friends.include?(friend)
      redirect_to personal_profile_path(friend), alert: 'Sei già amico di questo utente.'
    else
    current_user.friends << friend unless current_user.friends.include?(friend) || friend == current_user
    redirect_to personal_profile_path(friend), notice: 'Amico aggiunto con successo!'
  end
end
