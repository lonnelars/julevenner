class Auth0Controller < ApplicationController
  def callback
    # OmniAuth stores the information returned from Auth0 and the IdP in request.env['omniauth.auth'].
    # In this code, you will pull the raw_info supplied from the id_token and assign it to the session.
    # Refer to https://github.com/auth0/omniauth-auth0/blob/master/EXAMPLES.md#example-of-the-resulting-authentication-hash for complete information on 'omniauth.auth' contents.
    auth_info = request.env["omniauth.auth"]
    session[:userinfo] = auth_info["extra"]["raw_info"]

    # Redirect to the URL you want after successful auth
    email = session[:userinfo].name
    user = User.find_by(email: email)
    redirect_to "/groups/#{user.group_id}"
  end

  def failure
    @error_msg = request.params["message"]
  end

  def logout
    reset_session
    redirect_to logout_url, allow_other_host: true
  end

  private

  def logout_url
    auth0 = Rails.application.credentials.auth0
    request_params = {
      returnTo: root_url,
      client_id: auth0.client_id
    }

    URI::HTTPS.build(host: auth0.domain, path: "/v2/logout", query: request_params.to_query).to_s
  end
end
