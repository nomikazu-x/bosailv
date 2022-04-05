class Api::V1::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    json_string = UserSerializer.new(@user).serializable_hash.to_json
    render json: json_string
  end
end
