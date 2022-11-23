class Api::V1::Admin::UsersController < Api::V1::ApplicationController
  before_action :redirect_not_admin, only: %i[index destroy]

  # GET /api/v1/users(.json) ユーザー情報一覧取得API
  def index
    keyword = params[:keyword]&.slice(..(255 - 1))

    @users = User.search(keyword).page(params[:page]).per(Settings['default_users_limit'])
    render './api/v1/users/index'
  end

  # POST /api/v1/users/:username/delete(.json) ユーザー削除API(管理者専用)
  def destroy
    user = User.find_by(username: params[:username])
    if user
      user.destroy
      render './api/v1/success', locals: { notice: I18n.t('notice.user.destroy') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.user.destroy.failure') }, status: :unprocessable_entity
    end
  end
end
