class Auth0Controller < ApplicationController

  skip_before_action :verify_authenticity_token
  skip_authorization_check
  def callback
    # OmniAuth stores the information returned from Auth0 and the IdP in request.env['omniauth.auth'].
    # In this code, you will pull the raw_info supplied from the id_token and assign it to the sessions.
    auth_info = request.env['omniauth.auth']
    # Estrai le informazioni dell'utente
    auth0_id = auth_info['uid']
    email = auth_info['info']['email']
    name = auth_info['info']['name']
    response = Auth0Service.get_user_info(auth0_id)
    username = response["username"] || name

    provider = (auth0_id.split('|').first).split("-").first

    #Find or create a user based on the Auth0 UID
    user = RegisteredUser.find_or_create_by!(email: email) do |user|
      user.username = response["username"]
      user.email = email
      user.is_admin = false
      user.auth0_id = auth0_id
      user.provider = provider
      user.password = "auth0"
    end
    user.update(username: username) if user.username.nil?

    # Check if
    if user.auth0_id.nil?
      user.update(auth0_id: auth0_id)
    end
    if user.provider.nil?
      user.update(provider: provider)
    end
    session[:userinfo] = {
      'auth0_id' => user.auth0_id,
      'name' => user.username,
      'email' => user.email,
      'user_id' => user.id
    }

    cookies[:user_info] = { value: user.id, expires: 1.year.from_now }

    session[:user_id] = user.id
    redirect_to root_path
  end

  def failure
    error_type = params[:error]
    error_description = params[:error_description]

    flash[:alert] = "Authentication failed: #{error_description} Please try again."
    cookies.delete :user_info
    # Redirect to a specific page with an error message
    redirect_to root_path
  end

  def logout
    if current_user.guest?
      Guest.find(current_user.id).destroy
      flash[:success] = "You have been logged out."
      redirect_to root_url
    else
      if RegisteredUser.find(current_user.id).has_auth0?
        reset_session
        cookies.delete :user_info
        flash[:success] = "You have been logged out."
        redirect_to logout_url, allow_other_host: true
      else
        reset_session
        cookies.delete :user_info
        flash[:success] = "You have been logged out."
        redirect_to root_url
      end
    end
  end

  private

  def logout_url
    domain = Rails.application.credentials.auth0_api['auth0_domain']
    client_id = Rails.application.credentials.auth0_api['auth0_client_id']
    return_to_url = 'http://localhost:3000/' # Assicurati che questo URL sia nella lista degli URL di logout consentiti in Auth0

    request_params = {
      returnTo: return_to_url,
      client_id: client_id
    }

    URI::HTTPS.build(host: domain, path: '/v2/logout', query: request_params.to_query).to_s
  end
end