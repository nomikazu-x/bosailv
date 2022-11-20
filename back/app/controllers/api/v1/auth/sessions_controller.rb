class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token
  prepend_before_action :unauthenticated_response_sign_out, only: %i[destroy], unless: :user_signed_in?
  prepend_before_action :update_request_uid_header

  # POST /api/v1/auth/sign_in(.json) ログインAPI(処理)
  def create
    return render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.sessions.bad_credentials') }, status: :bad_request if request.request_parameters.blank?

    if params[:unlock_redirect_url].blank?
      return render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.sessions.unlock_redirect_url_blank') }, status: :unprocessable_entity
    end

    if blacklisted_redirect_url?(params[:unlock_redirect_url])
      return render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.sessions.unlock_redirect_url_not_allowed') }, status: :unprocessable_entity
    end

    return render_create_error_bad_credentials if params[:email].blank? || params[:password].blank?

    super
  end

  # POST /api/v1/auth/guest_sign_in(.json) ゲストログインAPI(処理)
  def create_guest
    user = User.create!(guest_user_params)
    render json: { email: user.email, password: user.password }
  end

  # POST /api/v1/auth/sign_out(.json) ログアウトAPI(処理)
  def destroy
    return render './api/v1/failure', locals: { alert: I18n.t('devise.sessions.already_signed_out') }, status: :unauthorized unless user_signed_in?

    super
  end

  private

  def find_resource(field, value)
    super
    @resource.redirect_url = params[:unlock_redirect_url] if @resource.present? && params[:unlock_redirect_url].present?
    @resource
  end

  def unauthenticated_response_sign_out
    render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.sessions.user_not_found') }, status: :unauthorized
  end

  def guest_user_params
    code = create_unique_code(User, 'code', "Api::V1::Auth::SessionsController.create_guest #{params}")
    username = SecureRandom.alphanumeric(5)
    email = "guest#{username}@bosailv.com"

    {
      code: code,
      username: username,
      name: "ゲスト@" + username,
      email: email,
      password: ENV['GUEST_USER_PASSWORD'],
      provider: 'email',
      uid: email,
      confirmed_at: Time.current,
      destroy_schedule_at: Time.current + Settings['destroy_schedule_days'].days
    }
  end

  protected

  def render_create_success
    render './api/v1/auth/success', locals: { notice: I18n.t('devise.sessions.signed_in') }
  end

  def render_create_error_not_confirmed
    render './api/v1/failure', locals: { alert: I18n.t('devise.failure.unconfirmed') }, status: :unprocessable_entity
  end

  def render_create_error_account_locked
    render './api/v1/failure', locals: { alert: I18n.t('devise.failure.locked') }, status: :unprocessable_entity
  end

  def render_create_error_bad_credentials
    if @resource.blank?
      render './api/v1/failure', locals: { alert: I18n.t('devise.failure.not_found_in_database') }, status: :unprocessable_entity
    elsif @resource.access_locked?
      render './api/v1/failure', locals: { alert: I18n.t('devise.failure.send_locked') }, status: :unprocessable_entity
    elsif Devise.lock_strategy == :failed_attempts && @resource.failed_attempts == Devise.maximum_attempts - 1
      render './api/v1/failure', locals: { alert: I18n.t('devise.failure.last_attempt') }, status: :unprocessable_entity
    else
      render './api/v1/failure', locals: { alert: I18n.t('devise.failure.invalid') }, status: :unprocessable_entity
    end
  end

  def render_destroy_success
    render './api/v1/auth/success', locals: { notice: I18n.t('devise.sessions.signed_out') }
  end
end
