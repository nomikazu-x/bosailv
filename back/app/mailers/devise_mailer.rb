class DeviseMailer < Devise::Mailer
  def headers_for(action, opts)
    super.merge!(template_path: 'mailer')
  end

  # メールアドレス確認のお願い
  def confirmation_instructions(record, token, opts = {})
    opts[:redirect_url] = record.redirect_url if record.is_a?(User) && record.redirect_url.present? # Tips: /api/v1/updateで使用
    send_mail(super)
  end

  # パスワード再設定方法のお知らせ
  def reset_password_instructions(record, token, opts = {})
    send_mail(super)
  end

  # アカウントロックのお知らせ
  def unlock_instructions(record, token, opts = {})
    opts[:redirect_url] = record.redirect_url if record.is_a?(User) && record.redirect_url.present? # Tips: /api/v1/sign_inで使用
    send_mail(super)
  end

  # メールアドレス変更受け付けのお知らせ
  def email_changed(record, opts = {})
    send_mail(super)
  end

  # パスワード変更完了のお知らせ
  def password_change(record, opts = {})
    send_mail(super)
  end

  private

  # メール送信
  def send_mail(mail)
    mail.from = "\"#{Settings['mailer_from']['name'].gsub(/%{app_name}/, I18n.t('app_name'))}\" <#{Settings['mailer_from']['email']}>"
    mail.subject = mail.subject.gsub(/%{app_name}/, I18n.t('app_name')).gsub(/%{env_name}/, Settings['env_name'])
    mail
  end
end