  # ./config/routes.rb

Rails.application.routes.draw do
  root 'welcome#index'
  get '/auth/auth0', to: redirect('/auth/auth0')
  get '/dashboard' => 'dashboard#show'
  get '/auth/auth0/callback' => 'auth0#callback'
  get '/auth/failure' => 'auth0#failure'
  get '/auth/logout' => 'auth0#logout'
  get '/auth/redirect' => 'auth0#redirect'
  get '/auth/register', to: redirect('https://dev-clyklmmz4z2hbpdz.us.auth0.com/authorize?client_id=F3RKbMB0iW8YTxwmfCg922F0hsio17PC&response_type=code&redirect_uri=http://localhost:3000&scope=openid%20profile%20email&screen_hint=signup')

  
end

