Rails.application.routes.draw do
  get 'database/info'
  root 'welcome#index'

  resources :challenges, only: [:new, :create, :show, :index]

  get 'profile', to: 'profiles#user_profile', as: 'profile'
  get 'admin_profile', to: 'profiles#admin_profile', as: 'admin_profile'

  post 'challenges/:id/update_status', to: 'profiles#update_status', as: 'update_status'

  get 'database_info', to: 'database#info', as: 'info'

  post 'clear_tables', to: 'database#clear_tables'
end
