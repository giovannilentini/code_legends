Rails.application.routes.draw do
  root 'welcome#index'
  resources :challenges, only: [:new, :create, :show, :index]
end

