Rails.application.routes.draw do
  root 'welcome#index'

  get 'settings/edit'
  get 'settings/update'
  get '/logged_index', to: 'welcome#logged_index'
  # Rotte per Auth0
  get '/auth/auth0', to: redirect('/auth/auth0')
  get '/auth/auth0/callback', to: 'auth0#callback'
  get '/auth/failure', to: 'auth0#failure'
  get '/auth/logout', to: 'auth0#logout'
  get '/auth/redirect', to: 'auth0#redirect'
  get '/auth/register', to: redirect('https://dev-clyklmmz4z2hbpdz.us.auth0.com/authorize?client_id=F3RKbMB0iW8YTxwmfCg922F0hsio17PC&response_type=code&redirect_uri=http://localhost:3000&scope=openid%20profile%20email&screen_hint=signup')
  resources :challenges, only: [:new, :create, :show, :index] do
    member do
      post 'update_status'
    end
  end

  get 'profile', to: 'profiles#user_profile', as: 'profile'
  get 'admin_profile', to: 'profiles#admin_profile', as: 'admin_profile'

  resources :profiles do
    post 'promote_to_admin/:id', to: 'profiles#promote_to_admin', as: 'promote_to_admin', on: :collection
  end

  resource :settings, only: [:edit, :update]
  get 'database/info'
  get 'database_info', to: 'database#info', as: 'info'
  post 'clear_tables', to: 'database#clear_tables'
  get 'play_now', to: 'matchmaking#play_now'
  post 'find_opponent', to: 'matchmaking#find_opponent'
  post 'challenge_friend', to: 'matches#challenge_friend'
  get 'check_challenge', to: 'matches#check_challenge'
  post 'cancel_matchmaking', to: 'matchmaking#cancel'
  get 'waiting', to: 'matches#waiting'
  post 'execute_code', to: 'matches#execute_code'
  resources :matches, only: [:show]
end

