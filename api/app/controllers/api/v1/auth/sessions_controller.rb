class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController

  private

  def render_create_success 
    render './api/v1/auth/success', locals: { notice: I18n.t('devise.sessions.signed_in') }
  end

  def render_create_error_bad_credentials
    render './api/v1/failure', locals: { alert: I18n.t('devise.failure.not_found_in_database') }, status: :unprocessable_entity
  end

  def render_destroy_success
    render './api/v1/auth/success', locals: { notice: I18n.t('devise.sessions.signed_out') }
  end
end
