class Api::V1::Users::Auth::TokenValidationsController < DeviseTokenAuth::TokenValidationsController

  private

  def render_validate_token_success
    render './api/v1/users/auth/success', locals: { notice: false }
  end

  def render_validate_token_error
    render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.token_validations.invalid') }, status: :unauthorized
  end
end
