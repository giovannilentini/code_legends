Rails.application.routes.draw do
  root 'welcome#home'

  get 'settings/edit'
  get 'settings/update'
  # Rotte per Auth0
  get '/auth/auth0/callback', to: 'auth0#callback', as: 'auth0_login'
  get '/auth/failure', to: 'auth0#failure', as: 'auth_failure'
  get '/auth/logout', to: 'auth0#logout', as: 'auth_logout'
  resources :challenges, only: [:new, :create, :show, :home] do
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

  resources :matches, only: [:show] do
    post 'execute_code', to: 'matches#execute_code'
    post 'surrender', to: 'matches#surrender'
  end

  get 'database/info'
  get 'database_info', to: 'database#info', as: 'info'
  post 'clear_tables', to: 'database#clear_tables'
  get 'play_now', to: 'matchmaking_queue#play_now'
  post 'find_opponent', to: 'matchmaking_queue#find_opponent'
  post 'cancel_matchmaking', to: 'matchmaking_queue#cancel'
  get 'waiting', to: 'matches#waiting'



  resources :matches, only: [:show]
end

