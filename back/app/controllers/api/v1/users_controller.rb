class Api::V1::UsersController < Api::V1::ApplicationController

  # GET /api/v1/users/ranking(.json) ユーザーランキング取得API
  def index
    # ユーザーを獲得ポイント順に取得
    @users = User.by_point_ranking.page(params[:page]).per(Settings['default_users_limit'])
  end

  # GET /api/v1/users/:username(.json) ユーザー情報詳細取得API
  def show
    @user = User.find_by(username: params[:username])

    return head :not_found if @user.blank?
  end
end
