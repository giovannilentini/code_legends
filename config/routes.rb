Rails.application.routes.draw do

  # ROOT ROUTE
  root 'welcome#home'

  # GUESTS ROUTES
  post 'guests/create', to: 'guests#create', as: 'create_guest'

  # AUTH0 ROUTES
  get '/auth/auth0/callback', to: 'auth0#callback', as: 'auth0_login'
  get '/auth/failure', to: 'auth0#failure', as: 'auth_failure'
  get '/auth/logout', to: 'auth0#logout', as: 'auth_logout'


  # USER / SETTINGS ROUTES
  resources :users, only: [:show] do
    post 'users/:id/add_friend', to: 'friendships#create', as: 'add_friend'
  end
  resources :users, only: [:update, :edit]
  #patch '/profile', to: 'profiles#update', as: 'profile_update'
  # ADMIN ROUTES
  resources :admins, only: [:show] do
    post 'promote_to_admin', to: 'admins#promote_to_admin'
  end

  # FRIEND REQUESTS ROUTES
  resources :friend_requests, only: [:create] do
    member do
      post 'accept'
      post 'reject'
    end
  end

  # MATCHES ROUTES
  resources :matches, only: [:show] do
    post 'execute_code', to: 'matches#execute_code'
    post 'surrender', to: 'matches#surrender'
    post 'timeout', to: 'matches#timeout'

  end
  resources :matches do
    resources :chat_messages, only: [:create]
    post 'execute_code', on: :member
    post 'surrender', on: :member
  end

  # CHALLENGE REQUESTS ROUTES
  resources :challenge_requests, only: [:index, :create] do
    member do
      post 'accept'
      post 'reject'
    end
  end

  # DATABASE ROUTES
  get 'database/info'
  get 'database_info', to: 'database#info', as: 'info'
  post 'clear_tables', to: 'database#clear_tables'

  # PLAYNOW ROUTES
  get 'play_now', to: 'matchmaking_queue#play_now'
  scope '/play_now' do
    post 'find_opponent', to: 'matchmaking_queue#find_opponent'
    post 'cancel_matchmaking', to: 'matchmaking_queue#cancel'
  end

  # LEADERBOARD ROUTES
  get 'leaderboard', to: 'leaderboards#index'


  # CHALLENGE PROPOSALS ROUTES
  resources :challenge_proposals, only: [:new, :create, :show]
  resources :challenge_proposals do
    member do
      post 'reject'
    end
  end

  # CHALLENGES ROUTES
  resources :challenges, only: [:show, :new, :create, :edit, :update, :destroy]

  get 'space_invaders', to: 'space_invaders#index'

end
