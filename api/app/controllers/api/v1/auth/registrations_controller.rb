class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  before_action :authenticate_api_v1_user!, except: %i[create new]

  def edit
    json_string = UserSerializer.new(current_api_v1_user).serializable_hash.to_json
    render json: json_string
  end

  private
  def sign_up_params
    params.permit(:email, :password, :username).merge(username: default_username)
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

  def default_username
    SecureRandom.alphanumeric(15)
  end

end
