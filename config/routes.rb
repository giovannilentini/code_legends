Rails.application.routes.draw do
  get 'database/info'
  root 'welcome#index'

  resources :challenges, only: [:new, :create, :show, :index]

  get 'database_info', to: 'database#info', as: 'info'

  post 'clear_tables', to: 'database#clear_tables'
end

