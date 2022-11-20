class Api::V1::Auth::UnlocksController < DeviseTokenAuth::UnlocksController
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token
  prepend_before_action :already_authenticated_response, only: %i[create], if: :user_signed_in?
  prepend_before_action :update_request_uid_header
  before_action :validate_redirect_url_param, only: %i[create show]

  # POST /api/v1/auth/unlock(.json) アカウントロック解除API[メール再送](処理)
  def create
    return render_create_error_missing_email if request.request_parameters.blank?
    return render_create_error_missing_redirect_url unless @redirect_url
    return render_error_not_allowed_redirect_url if blacklisted_redirect_url?(@redirect_url)

    @email = get_case_insensitive_field_from_resource_params(:email)
    @resource = find_resource(:email, @email)

    # Tips: 未ロックの場合はエラーにする
    if @resource.present? && !@resource.access_locked?
      return render './api/v1/failure', locals: { alert: I18n.t('errors.messages.not_locked') }, status: :unprocessable_entity
    end

    if @resource
      yield @resource if block_given?

      @resource.send_unlock_instructions(
        email: @email,
        provider: 'email',
        redirect_url: @redirect_url, # Tips: 追加
        client_config: params[:config_name]
      )

      if @resource.errors.empty?
        render_create_success
      else
        render_create_error @resource.errors
      end
    else
      render_not_found_error
    end
  end

  # GET /api/v1/auth/unlock アカウントロック解除(処理)
  def show
    @resource = resource_class.unlock_access_by_token(params[:unlock_token])

    if @resource.persisted?
      @resource.save!
      yield @resource if block_given?

      return redirect_to Settings['unlock_success_url_not'] if @redirect_url.blank?
      return redirect_to Settings['unlock_success_url_bad'] if blacklisted_redirect_url?(@redirect_url)

      redirect_header_options = { unlock: true, notice: I18n.t('devise.unlocks.unlocked') }
      redirect_to DeviseTokenAuth::Url.generate(@redirect_url, redirect_header_options)
    else
      render_show_error
    end
  end

  private

  def validate_redirect_url_param
    @redirect_url = params.fetch(:redirect_url, Settings['default_unlock_success_url'])
  end

  def render_create_error_missing_redirect_url
    render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.unlocks.missing_redirect_url') }, status: :unprocessable_entity
  end

  def render_error_not_allowed_redirect_url
    render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.unlocks.not_allowed_redirect_url') }, status: :unprocessable_entity
  end

  def render_create_error_missing_email
    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.validate_unlock_params') }, status: :bad_request
  end

  def render_create_success
    render './api/v1/auth/success', locals: { current_user: nil, notice: success_message('unlocks', @email) }
  end

  def render_create_error(errors)
    render './api/v1/failure', locals: { errors: errors }, status: :unprocessable_entity
  end

  def render_show_error
    return redirect_to Settings['unlock_error_url_not'] if @redirect_url.blank?
    return redirect_to Settings['unlock_error_url_bad'] if blacklisted_redirect_url?(@redirect_url)

    alert = I18n.t("activerecord.errors.models.user.attributes.unlock_token.#{params[:unlock_token].blank? ? 'blank' : 'invalid'}")
    redirect_header_options = { unlock: false, alert: alert }
    redirect_to DeviseTokenAuth::Url.generate(@redirect_url, redirect_header_options)
  end

  def render_not_found_error
    if Devise.paranoid
      render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.unlocks.sended_paranoid') }, status: :unprocessable_entity
    else
      errors = { email: I18n.t('devise_token_auth.unlocks.user_not_found') }
      errors[:full_messages] = ["#{I18n.t('activerecord.attributes.user.email')} #{errors[:email]}"]
      render './api/v1/failure', locals: { errors: errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
    end
  end
end
