class Users::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def show
    render './users/auth/show'
  end

  def image_update
    @user = User.find(current_user.id)
    if @user.update(params.permit(:image))
      update_auth_header
      render './users/auth/success', locals: { notice: I18n.t('notice.user.image_update') }
    else
      render './failure', locals: { errors: @user.errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
    end
  end

  def image_destroy
    @user = User.find(current_user.id)
    @user.remove_image!
    @user.save!
    render './users/auth/success', locals: { notice: I18n.t('notice.user.image_destroy') }
  end

  private

  def sign_up_params
    params.permit(:name, :email, :password, :username).merge(username: default_username)
  end

  def account_update_params
    params.permit(:name, :username, :image, :profile, :address)
  end

  def default_username
    SecureRandom.alphanumeric(15)
  end

  def render_create_success
    render './users/auth/success', locals: { notice: I18n.t('devise.registrations.signed_up') }
  end

  def render_create_error
    render './failure', locals: { errors: resource_errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
  end

  def render_update_success
    update_auth_header

    render './users/auth/success', locals: { notice: I18n.t('devise.registrations.updated') }
  end

  def render_update_error
    render './failure', locals: { errors: resource_errors, alert: I18n.t('errors.messages.not_saved.one') }, status: :unprocessable_entity
  end

  def render_destroy_success
    render './users/auth/success', locals: { notice: I18n.t('devise.registrations.destroyed') }
  end

  def render_destroy_error
    render './failure', locals: { errors: resource_errors, alert: I18n.t('devise.failure.unauthenticated') }, status: :unprocessable_entity
  end

  def validate_sign_up_params
    render './failure', locals: { alert: I18n.t('errors.messages.validate_sign_up_params') }, status: :bad_request if sign_up_params.empty?
  end

  def validate_account_update_params
    render './failure', locals: { alert: I18n.t('errors.messages.validate_account_update_params') }, status: :bad_request if account_update_params.empty?
  end
end
