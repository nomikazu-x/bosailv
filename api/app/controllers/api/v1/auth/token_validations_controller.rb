class Api::V1::Auth::TokenValidationsController < DeviseTokenAuth::TokenValidationsController 
  def render_validate_token_success
    json_string = UserSerializer.new(@resource).serializable_hash.to_json
    render json: json_string
  end 
end
