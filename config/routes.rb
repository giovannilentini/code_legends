Rails.application.routes.draw do
  get 'challenges/show'
  root 'welcome#index'
  get 'play_now', to: 'matchmaking#play_now'
  post 'find_opponent', to: 'matchmaking#find_opponent'
  post 'challenge_friend', to: 'challenges#challenge_friend'
  get 'check_challenge', to: 'challenges#check_challenge'
  get 'waiting', to: 'challenges#waiting'
  post 'execute_code', to: 'challenges#execute_code'
  resources :matches, only: [:show, :create]
  resources :rooms, only: [:show]
end

