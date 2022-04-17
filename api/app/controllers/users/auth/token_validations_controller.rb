class Users::Auth::TokenValidationsController < DeviseTokenAuth::TokenValidationsController
  def render_validate_token_success
    render './users/auth/success'
  end
end
