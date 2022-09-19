class Api::V1::Auth::ConfirmationsController < DeviseTokenAuth::ConfirmationsController

  # POST /api/v1/auth/confirmation(.json) メールアドレス確認API[メール再送](処理)
  # def create
  #   super
  # end

  # GET /api/v1/auth/confirmation メールアドレス確認(処理)
  def show
    super
  rescue ActionController::RoutingError => _e
    redirect_to(Rails.application.config.redirect_system_error_url)
  end
end
