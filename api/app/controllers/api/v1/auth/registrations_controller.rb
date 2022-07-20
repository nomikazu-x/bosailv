class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController

  # POST /api/v1/auth/sign_up(.json) アカウント登録API(処理)
  # def create
  #   super
  # end

  # POST /api/v1/auth/update(.json) 登録情報変更API(処理)
  # def update
  #   super
  # end

  # POST /api/v1/auth/task/update(.json) タスク更新API(処理)
  def task_update
    @user = User.find(current_user.id)
    case params
    when [:sns_tasks]
      @user.sns_task.set([:sns_tasks])
      if @user.update(params.permit(:sns_tasks))
        update_auth_header # 成功時のみ認証情報を返す
        render './api/v1/auth/success'
      else
        render './api/v1/failure', status: :unprocessable_entity
      end
    when [:house_tasks]
      @user.house_task.set([:house_tasks])
      if @user.update(params.permit(:house_tasks))
        update_auth_header # 成功時のみ認証情報を返す
        render './api/v1/auth/success'
      else
        render './api/v1/failure', status: :unprocessable_entity
      end
    else
      reder './api/v1/failure'
    end
  end

  # POST /api/v1/auth/task/delete(.json) タスクリセットAPI(処理)
  def task_destroy
    @user = User.find(current_user.id)
    case params
    when [:sns_task]
      @user.sns_task.unset(task)
      if @user.update(params.permit(:sns_task))
        update_auth_header # 成功時のみ認証情報を返す
        render './api/v1/auth/success'
      else
        render './api/v1/failure', status: :unprocessable_entity
      end
    when [:house_task]
      @user.house_task.unset(task)
      if @user.update(params.permit(:house_task))
        update_auth_header # 成功時のみ認証情報を返す
        render './api/v1/auth/success'
      else
        render './api/v1/failure', status: :unprocessable_entity
      end
    else
      reder './api/v1/failure'
    end
  end

  # POST /api/v1/auth/image/update(.json) 画像変更API(処理)
  def image_update
    @user = User.find(current_user.id)
    if @user.update(params.permit(:image))
      update_auth_header # 成功時のみ認証情報を返す
      render './api/v1/auth/success', locals: { notice: I18n.t('notice.user.image_update') }
    else
      render './api/v1/failure', locals: { errors: @user.errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/auth/image/delete(.json) 画像削除API(処理)
  def image_destroy
    @user = User.find(current_user.id)
    @user.remove_image!
    @user.save!
    render './api/v1/auth/success', locals: { notice: I18n.t('notice.user.image_destroy') }
  end

  # POST /api/v1/auth/delete(.json) アカウント削除API(処理)
  # def destroy
  #   super
  # end

  private

  def sign_up_params
    params.permit(:name, :email, :password, :username).merge(username: default_username)
  end

  def account_update_params
    params.permit(:name, :image, :email, :password, :profile, :username, :prefecture_id, :city_id)
  end

  def render_create_success
    @required_point = RequiredPoint.find_by(level: current_user.level).point
    @prefecture = Prefecture.find(current_user.prefecture_id) if current_user.prefecture_id.present?
    @city = City.find(current_user.city_id) if current_user.prefecture_id.present?
    render './api/v1/auth/success', locals: { notice: I18n.t('devise.registrations.signed_up') }
  end

  def render_create_error
    render './api/v1/failure', locals: { errors: resource_errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
  end

  def render_update_success
    @required_point = RequiredPoint.find_by(level: current_user.level).point
    @prefecture = Prefecture.find(current_user.prefecture_id) if current_user.prefecture_id.present?
    @city = City.find(current_user.city_id) if current_user.prefecture_id.present?
    update_auth_header

    render './api/v1/auth/success', locals: { notice: I18n.t('devise.registrations.updated') }
  end

  def render_update_error
    render './api/v1/failure', locals: { errors: resource_errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
  end

  def render_destroy_success
    render './api/v1/auth/success', locals: { notice: I18n.t('devise.registrations.destroyed') }
  end

  def render_destroy_error
    render './api/v1/failure', locals: { errors: resource_errors, alert: I18n.t('devise.failure.unauthenticated') }, status: :unprocessable_entity
  end

  def validate_sign_up_params
    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.validate_sign_up_params') }, status: :bad_request if sign_up_params.empty?
  end

  def validate_account_update_params
    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.validate_account_update_params') }, status: :bad_request if account_update_params.empty?
  end

  def default_username
    SecureRandom.alphanumeric(15)
  end
end
