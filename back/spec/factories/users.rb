# == Schema Information
#
# Table name: users
#
#  id                                                            :bigint           not null, primary key
#  allow_password_change(パスワード再設定中)                     :boolean          default(FALSE)
#  confirmation_sent_at(メールアドレス確認送信日時)              :datetime
#  confirmation_token(メールアドレス確認トークン)                :string(255)
#  confirmed_at(メールアドレス確認日時)                          :datetime
#  current_sign_in_at(現在のログイン日時)                        :datetime
#  current_sign_in_ip(現在のログインIPアドレス)                  :string(255)
#  email(メールアドレス)                                         :string(255)      default(""), not null
#  encrypted_password(認証方法)                                  :string(255)      default(""), not null
#  failed_attempts(連続ログイン失敗回数)                         :integer          default(0), not null
#  image(画像)                                                   :string(255)
#  infomation_check_last_started_at(お知らせ確認最終開始日時)    :datetime
#  last_sign_in_at(最終ログイン日時)                             :datetime
#  last_sign_in_ip(最終ログインIPアドレス)                       :string(255)
#  level(レベル)                                                 :integer          default(1), not null
#  lifelong_point(合計獲得ポイント)                              :integer          default(0), not null
#  locked_at(アカウントロック日時)                               :datetime
#  name(氏名)                                                    :string(30)       not null
#  point_to_next(現レベルにおける次のレベルまでに必要なポイント) :integer          default(5), not null
#  power(権限)                                                   :integer          default(NULL), not null
#  profile(自己紹介文)                                           :text(255)
#  provider(認証方法)                                            :string(255)      default("email"), not null
#  remember_created_at(ログイン状態維持開始日時)                 :datetime
#  reset_password_sent_at(パスワードリセット送信日時)            :datetime
#  reset_password_token(パスワードリセットトークン)              :string(255)
#  sign_in_count(ログイン回数)                                   :integer          default(0), not null
#  tokens(認証トークン)                                          :text(65535)
#  uid(UID)                                                      :string(255)      default(""), not null
#  unconfirmed_email(確認待ちメールアドレス)                     :string(255)
#  unlock_token(アカウントロック解除トークン)                    :string(255)
#  username(ユーザーネーム)                                      :string(30)       not null
#  created_at                                                    :datetime         not null
#  updated_at                                                    :datetime         not null
#  city_id(出身市区町村ID)                                       :integer
#  prefecture_id(出身都道府県ID)                                 :integer
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    code               { Digest::MD5.hexdigest(SecureRandom.uuid).to_i(16).to_s(36).rjust(25, '0') }
    sequence(:name)    { |n| "user(#{n})" }
    email              { Faker::Internet.safe_email(name: "#{name}#{Faker::Number.hexadecimal(digits: 3)}") }
    username           { SecureRandom.alphanumeric(15) }
    password           { Faker::Internet.password(min_length: 8) }
    confirmed_at       { '0000-01-01 00:00:00+0000' }
    sign_in_count      { 1 }
    current_sign_in_at { Time.now.utc - 1.hour }
    last_sign_in_at    { Time.now.utc - 2.hours }
    current_sign_in_ip { Faker::Internet.ip_v4_address }
    last_sign_in_ip    { Faker::Internet.ip_v4_address }

    # ロック中
    trait :locked do
      unlock_token    { Devise.token_generator.digest(self, :unlock_token, email) }
      locked_at       { Time.now.utc - 1.minute }
      failed_attempts { Devise.maximum_attempts }
    end

    # ロック前
    trait :before_lock1 do
      failed_attempts { Devise.maximum_attempts - 1 }
    end

    # ロック前の前
    trait :before_lock2 do
      failed_attempts { Devise.maximum_attempts - 2 }
    end

    # ロック前の前の前
    trait :before_lock3 do
      failed_attempts { Devise.maximum_attempts - 3 }
    end

    # メール未確認
    trait :unconfirmed do
      confirmation_token   { Devise.token_generator.digest(self, :confirmation_token, email) }
      confirmation_sent_at { Time.now.utc - 1.minute }
      confirmed_at         { nil }
    end

    # メールアドレス変更中
    trait :email_changed do
      confirmation_token   { Devise.token_generator.digest(self, :confirmation_token, email) }
      confirmation_sent_at { Time.now.utc - 1.minute }
      unconfirmed_email    { Faker::Internet.safe_email }
    end

    # メールアドレス変更期限切れ
    trait :expired_email_change do
      confirmation_token   { Devise.token_generator.digest(self, :confirmation_token, email) }
      confirmation_sent_at { Time.now.utc - User.confirm_within - 1.minute }
      unconfirmed_email    { Faker::Internet.safe_email }
    end

    # 削除予定(ゲスト)
    trait :destroy_reserved do
      destroy_schedule_at  { Time.current - 1.minute + Settings['destroy_schedule_days'].days }
    end

    # 削除対象
    trait :destroy_targeted do
      destroy_schedule_at  { Time.current - 1.minute }
    end
  end
end
