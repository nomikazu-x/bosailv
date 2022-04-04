class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController

  private
  def sign_up_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.permit(:name, :nickname, :image)
  end

  def render_create_success
    render './users/auth/success'
  end

  def render_update_success
    render './users/auth/success'
  end

end
