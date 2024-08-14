Rails.application.routes.draw do
  get 'play_now/index'
  get 'challenges/show'
  root 'welcome#index'
  get 'play_now', to: 'matchmaking#play_now'
  post 'find_opponent', to: 'challenges#create'
  post 'challenge_friend', to: 'challenges#challenge_friend'
  get 'check_challenge', to: 'challenges#check_challenge'
  get 'waiting', to: 'challenges#waiting' 
  resources :challenges, only: [:show, :create]
  resources :rooms, only: [:show]
end

