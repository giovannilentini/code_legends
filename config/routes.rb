Rails.application.routes.draw do
  root 'welcome#index'
  get 'challenges/new', to: 'challenges#new', as: 'new_challenge'
  post 'challenges', to: 'challenges#create'
end
