class Auth0Controller < ApplicationController
  def callback
    # OmniAuth stores the information returned from Auth0 and the IdP in request.env['omniauth.auth'].
    # In this code, you will pull the raw_info supplied from the id_token and assign it to the session.
    auth_info = request.env['omniauth.auth']
    session[:userinfo] = auth_info['extra']['raw_info']

    # Redirect to the home page for logged-in users
    redirect_to '/logged_index'
  end

  def failure
    @error_msg = request.params['message']
    # Redirect to a specific page with an error message
    redirect_to '/home', alert: "Authentication failed: #{@error_msg}"
  end

  def logout
    reset_session
    redirect_to logout_url, allow_other_host: true
  end

  private

  def logout_url
    domain = Rails.application.config.auth0['auth0_domain']
    client_id = Rails.application.config.auth0['auth0_client_id']
    return_to_url = 'http://localhost:3000/'
    request_params = {
      returnTo: return_to_url,
      client_id: client_id
    }
    URI::HTTPS.build(host: domain, path: '/v2/logout', query: request_params.to_query).to_s
  end
end
