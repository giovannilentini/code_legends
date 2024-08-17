Rails.application.routes.draw do

  resources :games do
    collection do
      post 'execute_code'
    end
  end

  get "welcome/index"
  root 'games#index'
end
