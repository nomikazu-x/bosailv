class Api::V1::Auth::TokenValidationsController < DeviseTokenAuth::TokenValidationsController

  # GET /api/v1/auth/validate_token(.json) トークン検証API(処理)
  # def validate_token
  #   super
  # end

  protected

  def render_validate_token_success
    @required_point = RequiredPoint.find_by(level: current_user.level).point
    @prefecture = Prefecture.find(current_user.prefecture_id) if current_user.prefecture_id.present?
    @city = City.find(current_user.city_code) if current_user.prefecture_id.present?
    render './api/v1/auth/success', locals: { notice: false }
  end

  def render_validate_token_error
    render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.token_validations.invalid') }, status: :unauthorized
  end
end
