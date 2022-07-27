class Api::V1::ApplicationController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token, if: :devise_controller?, raise: false
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  private

  def redirect_not_admin
    return if current_user.is_admin?

    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.not_permission') }, status: :unauthorized
  end
end
