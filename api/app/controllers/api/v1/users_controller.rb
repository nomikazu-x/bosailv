class Api::V1::UsersController < Api::V1::ApplicationController
  def ranking
    @users = User.point_ranking.page(params[:page]).per(Settings['default_users_limit'])
    render './api/v1/users/ranking'
  end

  def show
    @user = User.find_by(username: params[:username])
    if @user
      render './api/v1/users/show'
    else
      head :not_found
    end
  end
end