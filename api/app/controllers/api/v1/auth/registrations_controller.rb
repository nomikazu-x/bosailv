class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController

  private
  def sign_up_params
    params.permit(:email, :password)
  end

  def account_update_params
    params.permit(:name, :username, :image, :profile, :address)
  end

  def render_create_success
    json_string = UserSerializer.new(@resource).serializable_hash.to_json
    render json: json_string
  end

  def render_update_success
    json_string = UserSerializer.new(@resource).serializable_hash.to_json
    render json: json_string
  end

end
