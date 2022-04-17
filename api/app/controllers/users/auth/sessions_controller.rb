class Users::Auth::SessionsController < DeviseTokenAuth::SessionsController

  protected

  def render_create_success 
    render './users/auth/success'
  end
end
