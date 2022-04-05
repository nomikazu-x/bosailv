class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController 

  def render_create_success 
    render './users/auth/success', formats: :json
  end 

end
