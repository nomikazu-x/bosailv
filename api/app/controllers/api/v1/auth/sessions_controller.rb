class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController 

  def render_create_success 
    json_string = UserSerializer.new(@resource).serializable_hash.to_json
    render json: json_string
  end 

end
