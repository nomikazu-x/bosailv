class ApplicationController < ActionController::Base
  after_action :update_response_uid_header

  private

  # リクエストのuidヘッダを[id+36**2](36進数)からuidに変更 # Tips: uidがメールアドレスだと、メールアドレス確認後に認証に失敗する為
  def update_request_uid_header
    return if request.headers['uid'].blank?

    user = User.find_by(id: request.headers['uid'].to_i(36) - (36**2))
    request.headers['uid'] = user&.uid
  end

  # レスポンスのuidヘッダをuidから[id+36**2](36進数)に変更
  def update_response_uid_header
    return if response.headers['uid'].blank?

    user = User.find_by(uid: response.headers['uid'])
    response.headers['uid'] = user.present? ? (user.id + (36**2)).to_s(36) : nil
  end

  # URLの拡張子がないかを返却
  def format_html?
    request.format.html?
  end

  # 認証エラーを返却
  def unauthenticated_response
    render './api/v1/failure', locals: { alert: I18n.t('devise.failure.unauthenticated') }, status: :unauthorized
  end

  # 認証済みエラーを返却
  def already_authenticated_response
    render './api/v1/failure', locals: { alert: I18n.t('devise.failure.already_authenticated') }, status: :unauthorized
  end

  # パスワードリセットトークンのユーザーを返却
  def user_reset_password_token(token)
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, token)
    resource_class.find_by(reset_password_token: reset_password_token)
  end

  # メールアドレス確認済みかを返却
  def already_confirmed?(token)
    resource = resource_class.find_by(confirmation_token: token)
    resource&.confirmed_at&.present? && resource&.confirmation_sent_at&.present? && (resource.confirmed_at > resource.confirmation_sent_at)
  end

  # ユニークコードを作成して返却
  def create_unique_code(model, key, logger_message)
    try_count = 1
    loop do
      code = Digest::MD5.hexdigest(SecureRandom.uuid).to_i(16).to_s(36).rjust(25, '0') # Tips: 16進数32桁を36進数25桁に変換
      return code if model.where(key => code).blank?

      if try_count < 10
        logger.warn("[WARN](#{try_count})Not unique code(#{code}): #{logger_message}")
      elsif try_count >= 10
        logger.error("[ERROR](#{try_count})Not unique code(#{code}): #{logger_message}")
        return code
      end
      try_count += 1
    end
  end

  # 管理者でない場合、JSONでメッセージ返却
  def redirect_not_admin
    return if current_user.is_admin?

    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.not_permission') }, status: :unauthorized
  end
end
