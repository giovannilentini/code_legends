Rails.application.routes.draw do
  root 'welcome#index'

  get 'settings/edit'
  get 'settings/update'
  get '/logged_index', to: 'welcome#logged_index'
  # Rotte per Auth0
  get '/auth/auth0/callback' => 'auth0#callback'
  get '/auth/failure' => 'auth0#failure'
  get '/auth/logout' => 'auth0#logout'
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

  get 'users/:id', to: 'users#show', as: 'user_profile'
  post 'users/:id/add_friend', to: 'friendships#create', as: 'add_friend'

  get 'database/info'
  get 'database_info', to: 'database#info', as: 'info'
  post 'clear_tables', to: 'database#clear_tables'

  get 'play_now', to: 'matchmaking#play_now'
  post 'find_opponent', to: 'matchmaking#find_opponent'
  post 'challenge_friend', to: 'matches#challenge_friend'
  get 'check_challenge', to: 'matches#check_challenge'
  get 'waiting', to: 'matches#waiting'
  post 'execute_code', to: 'matches#execute_code'
  resources :matches, only: [:show]
end

