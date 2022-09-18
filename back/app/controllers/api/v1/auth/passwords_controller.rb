class Api::V1::Auth::PasswordsController < DeviseTokenAuth::PasswordsController
  
  # POST /api/v1/auth/password(.json) パスワード再設定API[メール送信](処理)
  # def create
  #   super
  # end

  # GET /api/v1/auth/password パスワード再設定
  # def edit
  #   super
  # end

  # POST /api/v1/auth/password/update(.json) パスワード再設定API(処理)
  # def update
  #   super
  # end
  
  protected

  # エラー画面にリダイレクトする
  def render_edit_error
    redirect_to(Rails.application.config.redirect_system_error_url)
  end
end
