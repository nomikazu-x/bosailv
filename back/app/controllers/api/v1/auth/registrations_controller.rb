class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  include Api::V1::Auth::RegistrationsConcern
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token
  prepend_before_action :unauthenticated_response, only: %i[show update image_update image_destroy destroy], unless: :user_signed_in?
  prepend_before_action :already_authenticated_response, only: %i[create], if: :user_signed_in?
  prepend_before_action :update_request_uid_header
  before_action :configure_sign_up_params, only: %i[create]
  before_action :configure_account_update_params, only: %i[update]
  skip_after_action :update_auth_header, only: %i[update image_update]

  # POST /api/v1/auth/sign_up(.json) アカウント登録API(処理)
  def create
    params[:code] = create_unique_code(User, 'code', "Api::V1::Auth::RegistrationsController.create #{params}")
    params[:username] = SecureRandom.alphanumeric(15)

    super
  end

  # GET /api/v1/auth/detail(.json) ユーザー情報詳細API
  def show
    render './api/v1/auth/show'
  end

  # POST /api/v1/auth/update(.json) 登録情報変更API(処理)
  def update
    if params[:confirm_redirect_url].blank?
      return render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.registrations.confirm_redirect_url_blank') }, status: :unprocessable_entity
    end
    if blacklisted_redirect_url?(params[:confirm_redirect_url])
      return render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.registrations.confirm_redirect_url_not_allowed') }, status: :unprocessable_entity
    end

    # Tips: 存在するメールアドレスの場合はエラーにする
    if @resource.present? && @resource.email != params[:email] && User.find_by(email: params[:email]).present?
      errors = { email: I18n.t('activerecord.errors.models.user.attributes.email.taken') }
      errors[:full_messages] = ["#{I18n.t('activerecord.attributes.user.email')} #{errors[:email]}"]
      return render './api/v1/failure', locals: { errors: errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
    end

    params[:password_confirmation] = '' if params[:password_confirmation].nil? # Tips: nilだとチェックされずに保存される為
    params[:current_password] = '' if params[:current_password].nil? # Tips: nilだとチェックされずに保存される為

    @resource.redirect_url = params[:confirm_redirect_url]
    super
  end

  # POST /api/v1/auth/profile/update(.json) プロフィール変更API(処理)
  def profile_update
    @user = User.find(current_user.id)
    if @user.update(params.permit(:name, :profile, :prefecture_id, :city_id))
      # update_auth_header # 成功時のみ認証情報を返す
      render './api/v1/auth/success', locals: { notice: I18n.t('devise.registrations.updated') }
    else
      render './api/v1/failure', locals: { errors: @user.errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/auth/image/update(.json) 画像変更API(処理)
  def image_update
    if params[:image].blank? || params[:image].class != ActionDispatch::Http::UploadedFile
      errors = { image: I18n.t('errors.messages.image_update_blank') }
      errors[:full_messages] = ["#{I18n.t('activerecord.attributes.user.image')} #{errors[:image]}"]
      return render './api/v1/failure', locals: { errors: errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
    end

    @user = User.find(current_user.id)
    if @user.update(params.permit(:image))
      update_auth_header # 成功時のみ認証情報を返す
      render './api/v1/auth/success', locals: { notice: I18n.t('notice.user.image_update') }
    else
      render './api/v1/failure', locals: { errors: @user.errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/auth/image/delete(.json) 画像削除API(処理)
  def image_destroy
    @user = User.find(current_user.id)
    @user.remove_image!
    @user.save!
    render './api/v1/auth/success', locals: { notice: I18n.t('notice.user.image_destroy') }
  end

  # POST /api/v1/auth/delete(.json) アカウント削除API(処理)
  def destroy
    super
  end

  protected

  def render_create_error_missing_confirm_success_url
    render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.registrations.missing_confirm_success_url') }, status: :unprocessable_entity
  end

  def render_create_error_redirect_url_not_allowed
    render './api/v1/failure', locals: { alert: I18n.t('devise_token_auth.registrations.redirect_url_not_allowed') }, status: :unprocessable_entity
  end

  def render_create_success
    render './api/v1/auth/success', locals: { notice: I18n.t('devise.registrations.signed_up_but_unconfirmed') }
  end

  def render_create_error
    render './api/v1/failure', locals: { errors: resource_errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
  end

  def render_update_success
    update_auth_header # Tips: 成功時のみ認証情報を返す

    notice = @resource.unconfirmed_email.present? ? 'devise.registrations.update_needs_confirmation' : 'devise.registrations.updated'
    render './api/v1/auth/success', locals: { notice: I18n.t(notice) }
  end

  def render_update_error
    render './api/v1/failure', locals: { errors: resource_errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
  end

  def render_destroy_success
    render './api/v1/auth/success', locals: { notice: I18n.t('devise.registrations.destroyed') }
  end

  def render_destroy_error
    render './api/v1/failure', locals: { errors: resource_errors, alert: I18n.t('devise.failure.unauthenticated') }, status: :unprocessable_entity
  end

  private

  def account_update_params
    params.permit(:password, :password_confirmation, :current_password, :email)
  end

  def validate_sign_up_params
    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.validate_sign_up_params') }, status: :bad_request if sign_up_params.empty?
  end

  def validate_account_update_params
    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.validate_account_update_params') }, status: :bad_request if account_update_params.empty?
  end
end
