class Api::V1::Auth::ConfirmationsController < DeviseTokenAuth::ConfirmationsController
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token
  prepend_before_action :update_request_uid_header

  # POST /api/v1/auth/confirmation(.json) メールアドレス確認API[メール再送](処理)
  def create
    return render './api/v1/failure', locals: { alert: I18n.t('errors.messages.validate_confirmation_params') }, status: :bad_request if request.request_parameters.blank?

    if params[:redirect_url].blank?
      return render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.confirmations.missing_confirm_success_url') }, status: :unprocessable_entity
    end

    if blacklisted_redirect_url?(params[:redirect_url])
      return render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.confirmations.redirect_url_not_allowed') }, status: :unprocessable_entity
    end

    # Tips: 確認済み・不要の場合はエラーにする
    resource = params[:email].present? ? resource_class.find_by(email: params[:email]) : nil
    return render './api/v1/failure', locals: { alert: I18n.t('errors.messages.already_confirmed') }, status: :unprocessable_entity if already_confirmed?(resource)

    super
  end

  # GET /api/v1/auth/confirmation メールアドレス確認(処理)
  def show
    @resource = resource_class.confirm_by_token(resource_params[:confirmation_token])
    if @resource.errors.empty?
      yield @resource if block_given?

      return redirect_to Settings['confirmation_success_url_not'] if redirect_url.blank?
      return redirect_to Settings['confirmation_success_url_bad'] if blacklisted_redirect_url?(redirect_url)

      redirect_header_options = { account_confirmation_success: true, notice: I18n.t('devise.confirmations.confirmed') }

    elsif already_confirmed?(@resource)
      return redirect_to Settings['confirmation_success_url_not'] if redirect_url.blank?
      return redirect_to Settings['confirmation_success_url_bad'] if blacklisted_redirect_url?(redirect_url)

      redirect_header_options = { account_confirmation_success: true, alert: I18n.t('errors.messages.already_confirmed') }

    else
      return redirect_to Settings['confirmation_error_url_not'] if redirect_url.blank?
      return redirect_to Settings['confirmation_error_url_bad'] if blacklisted_redirect_url?(redirect_url)

      redirect_header_options = { account_confirmation_success: false, alert: I18n.t('activerecord.errors.models.user.attributes.confirmation_token.invalid') }
    end

    redirect_to DeviseTokenAuth::Url.generate(redirect_url, redirect_header_options)
  end

  private

  # 確認済み・不要かを返却
  def already_confirmed?(resource)
    resource&.confirmed_at&.present? && (resource.confirmation_sent_at.blank? || resource.confirmed_at > resource.confirmation_sent_at)
  end

  protected

  def render_create_success
    render './api/v1/auth/success', locals: { current_user: nil, notice: success_message('confirmations', @email) }
  end

  def render_not_found_error
    if Devise.paranoid
      render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.confirmations.sended_paranoid') }, status: :unprocessable_entity
    else
      errors = { email: I18n.t('devise_token_auth.confirmations.user_not_found') }
      errors[:full_messages] = ["#{I18n.t('activerecord.attributes.user.email')} #{errors[:email]}"]
      render './api/v1/failure', locals: { errors: errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
    end
  end
end
