class Api::V1::Users::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def show
    render './api/v1/users/auth/show'
  end

  def image_update
    @user = User.find(current_user.id)
    if @user.update(params.permit(:image))
      update_auth_header
      render './api/v1/users/auth/success', locals: { notice: I18n.t('notice.user.image_update') }
    else
      render './api/v1/failure', locals: { errors: @user.errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
    end
  end

  def image_destroy
    @user = User.find(current_user.id)
    @user.remove_image!
    @user.save!
    render './api/v1/users/auth/success', locals: { notice: I18n.t('notice.user.image_destroy') }
  end

  private

  def sign_up_params
    params.permit(:name, :email, :password)
  end

  def account_update_params
    params.permit(:name, :image)
  end

  def default_username
    SecureRandom.alphanumeric(15)
  end

  def render_create_success
    render './api/v1/users/auth/success', locals: { notice: I18n.t('devise.registrations.signed_up') }
  end

  def render_create_error
    render './api/v1/failure', locals: { errors: resource_errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
  end

  def render_update_success
    update_auth_header

    render './api/v1/users/auth/success', locals: { notice: I18n.t('devise.registrations.updated') }
  end

  def render_update_error
    render './api/v1/failure', locals: { errors: resource_errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
  end

  def render_destroy_success
    render './api/v1/users/auth/success', locals: { notice: I18n.t('devise.registrations.destroyed') }
  end

  def render_destroy_error
    render './api/v1/failure', locals: { errors: resource_errors, alert: I18n.t('devise.failure.unauthenticated') }, status: :unprocessable_entity
  end

  def validate_sign_up_params
    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.validate_sign_up_params') }, status: :bad_request if sign_up_params.empty?
  end

  def validate_account_update_params
    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.validate_account_update_params') }, status: :bad_request if account_update_params.empty?
  end
end
