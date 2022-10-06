class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController

  # POST /api/v1/auth/sign_in(.json) ログインAPI(処理)
  # def create
  #   super
  # end

  # POST /api/v1/auth/guest_sign_in(.json) ゲストログインAPI(処理)
  def create_guest
    ActiveRecord::Base.transaction do
      user = User.create!(guest_user_params)
      # サインインする
      # ゲストユーザーのメールアドレスとパスワードでパラメータを設定（パスワードは既定のもの）
      params.merge!(email: user.email, password: ENV['GUEST_USER_PASSWORD'])
      create
    end
  end

  # POST /api/v1/auth/sign_out(.json) ログアウトAPI(処理)
  # def destroy
  #   super
  # end

  private

  def render_create_success
    render './api/v1/auth/success', locals: { notice: I18n.t('devise.sessions.signed_in') }
  end

  def render_create_error_bad_credentials
    render './api/v1/failure', locals: { alert: I18n.t('devise.failure.not_found_in_database') }, status: :unprocessable_entity
  end

  def render_destroy_success
    render './api/v1/auth/success', locals: { notice: I18n.t('devise.sessions.signed_out') }
  end

  def guest_user_params
    username = 'guest' + SecureRandom.alphanumeric(5)
    email = "guest#{username}@bosailevel.com"

    {
      username: username,
      name: "ゲスト@" + username,
      email: email,
      password: ENV['GUEST_USER_PASSWORD'],
      provider: 'email',
      uid: email,
      confirmed_at: Time.current,
      destroy_schedule_at: Time.current + Settings['destroy_schedule_days'].minutes
    }
  end
end
