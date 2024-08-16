# ./config/routes.rb
Rails.application.routes.draw do
  root 'welcome#index'
  get '/logged_index' => 'welcome#logged_index'
  get '/auth/auth0', to: redirect('/auth/auth0')
  get '/auth/auth0/callback' => 'auth0#callback'
  get '/auth/failure' => 'auth0#failure'
  get '/auth/logout' => 'auth0#logout'
end
