class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController

  # POST /api/v1/auth/sign_in(.json) ログインAPI(処理)
  # def create
  #   super
  # end

  # POST /api/v1/auth/sign_out(.json) ログアウトAPI(処理)
  # def destroy
  #   super
  # end

  private

  def render_create_success
    @required_point = RequiredPoint.find_by(level: current_user.level).point
    @prefecture = Prefecture.find(current_user.prefecture_id) if current_user.prefecture_id.present?
    @city = City.find(current_user.city_id) if current_user.prefecture_id.present?
    render './api/v1/auth/success', locals: { notice: I18n.t('devise.sessions.signed_in') }
  end

  def render_create_error_bad_credentials
    render './api/v1/failure', locals: { alert: I18n.t('devise.failure.not_found_in_database') }, status: :unprocessable_entity
  end

  def render_destroy_success
    render './api/v1/auth/success', locals: { notice: I18n.t('devise.sessions.signed_out') }
  end
end
