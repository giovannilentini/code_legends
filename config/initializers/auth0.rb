
Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    Rails.application.credentials.auth0_api['auth0_client_id'],
    Rails.application.credentials.auth0_api['auth0_client_secret'],
    Rails.application.credentials.auth0_api['auth0_domain'],
    callback_path: '/auth/auth0/callback',
    authorize_params: {
      scope: 'openid profile email'
    },
  )
end

OmniAuth.config.on_failure = Proc.new do |env|
  Auth0Controller.action(:failure).call(env)
end