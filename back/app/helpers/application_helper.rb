module ApplicationHelper
  # 有効なメールアドレス確認トークンかを返却
  def user_valid_confirmation_token?
    return false unless devise_mapping.confirmable? && current_user.pending_reconfirmation?

    User.confirm_within.blank? || (Time.now.utc <= current_user.confirmation_sent_at.utc + User.confirm_within)
  end
end