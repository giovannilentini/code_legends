# ./config/routes.rb
Rails.application.routes.draw do
  get 'database/info'
  root 'welcome#index'
<<<<<<< HEAD
  get '/logged_index' => 'welcome#logged_index'

  # Route per il login tramite Auth0
  get '/auth/auth0', to: redirect('/auth/auth0')

  # Route per il callback di Auth0
  get '/auth/auth0/callback', to: 'auth0#callback'

  # Route per la gestione degli errori di Auth0
  get '/auth/failure', to: 'auth0#failure'

  # Route per il logout
  get '/auth/logout', to: 'auth0#logout'

  # Route per il redirect
  get '/auth/redirect', to: 'auth0#redirect'

  # Route per la registrazione
  get '/auth/register', to: redirect('https://dev-clyklmmz4z2hbpdz.us.auth0.com/authorize?client_id=F3RKbMB0iW8YTxwmfCg922F0hsio17PC&response_type=code&redirect_uri=http://localhost:3000&scope=openid%20profile%20email&screen_hint=signup')
=======

  resources :challenges, only: [:new, :create, :show, :index]

  get 'profile', to: 'profiles#user_profile', as: 'profile'
  get 'admin_profile', to: 'profiles#admin_profile', as: 'admin_profile'

  post 'challenges/:id/update_status', to: 'profiles#update_status', as: 'update_status'

  get 'database_info', to: 'database#info', as: 'info'

  post 'clear_tables', to: 'database#clear_tables'
>>>>>>> feature/profile-page
end
