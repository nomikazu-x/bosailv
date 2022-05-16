class Api::V1::Users::Auth::ConfirmationsController < DeviseTokenAuth::ConfirmationsController
  def show
    super
  rescue ActionController::RoutingError => _e
    redirect_to(Rails.application.config.redirect_system_error_url)
  end
end