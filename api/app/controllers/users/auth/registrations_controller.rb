class Users::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def show
    render './users/auth/show'
  end

  def image_update
    @user = User.find(current_user.id)
    if @user.update(params.permit(:image))
      update_auth_header # Tips: 成功時のみ認証情報を返す
      render './users/auth/success'
    else
      render './failure', status: :unprocessable_entity
    end
  end

  # POST /users/auth/image/delete(.json) 画像削除API(処理)
  def image_destroy
    @user = User.find(current_user.id)
    @user.remove_image!
    @user.save!
    render './users/auth/success'
  end

  private

  def sign_up_params
    params.permit(:name, :email, :password, :username).merge(username: default_username)
  end

  def account_update_params
    params.permit(:name, :username, :image, :profile, :address)
  end

  def render_create_success
    render './users/auth/success'
  end

  def render_update_success
    render './users/auth/success'
  end

  def default_username
    SecureRandom.alphanumeric(15)
  end

end
