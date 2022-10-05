# frozen_string_literal: true

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
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable
  include DeviseTokenAuth::Concerns::User

  mount_uploader :image, UserImageUploader

  alias_attribute :total, :lifelong_point
  alias_attribute :to_next, :point_to_next

  has_one :task_profile, dependent: :destroy
  has_one :family_rule, dependent: :destroy

  has_many :articles, dependent: :destroy
  has_many :infomations, dependent: :destroy
  has_many :article_favorites, dependent: :destroy
  has_many :article_comments, dependent: :destroy
  has_many :task_completes, dependent: :destroy
  has_many :point_records, dependent: :destroy
  has_many :favorited_articles, through: :article_favorites, source: :article
  has_many :emergency_contacts, dependent: :destroy
  has_many :families, dependent: :destroy
  has_many :shelter_registrations, dependent: :destroy
  has_many :registered_shelters, through: :shelter_registrations, source: :shelter

  scope :point_ranking, -> { order(lifelong_point: :desc, id: :desc) }
  scope :by_destroy_reserved, -> { where('destroy_schedule_at <= ?', Time.current) }

  VALID_USERNAME_REGEX = /\A[\w_]+\z/i
  VALID_PASSWORD_REGEX = /\A[!-~]+\z/

  validates :name, length: { maximum: 30 }
  validates :password, presence: true, format: { with: VALID_PASSWORD_REGEX }, allow_nil: true
  validates :username, length: { maximum: 30 }, uniqueness: true, allow_nil: true, presence: true, format: { with: VALID_USERNAME_REGEX }

  # 画像URLを返却
  def image_url(version)
    case version
    when :mini
      image? ? image.mini.url : "#{Settings['base_image_url']}/images/user/#{version}_noimage.jpg"
    when :small
      image? ? image.small.url : "#{Settings['base_image_url']}/images/user/#{version}_noimage.jpg"
    when :medium
      image? ? image.medium.url : "#{Settings['base_image_url']}/images/user/#{version}_noimage.jpg"
    when :large
      image? ? image.large.url : "#{Settings['base_image_url']}/images/user/#{version}_noimage.jpg"
    when :xlarge
      image? ? image.xlarge.url : "#{Settings['base_image_url']}/images/user/#{version}_noimage.jpg"
    else
      logger.warn("[WARN]Not found: User.image_url(#{version})")
      ''
    end
  end

  # お知らせの未読数
  def infomation_unread_count
    Infomation.by_target(self).by_unread(infomation_check_last_started_at).count
  end

  # 記事をお気に入りする
  def article_favorite!(article)
    article_favorites.create!(article_id: article.id)
  end

  # 記事をお気に入りを解除する
  def article_unfavorite!(article)
    article_favorite = article_favorites.find_by!(article_id: article.id)

    article_favorite.destroy
  end

  # 記事をお気に入りしているか
  def article_favorite?(article)
    article_favorites.exists?(article_id: article.id)
  end

  # 防災タスクを完了する
  def task_complete!(task)
    task_completes.create!(task_id: task.id)
  end

  # 防災タスクを未完了にする
  def task_uncomplete!(task)
    task_complete = task_completes.find_by!(task_id: task.id)

    task_complete.destroy
  end

  # 防災タスクを完了しているか
  def task_complete?(task)
    task_completes.exists?(task_id: task.id)
  end

  # 避難所を登録する
  def shelter_registration!(shelter)
    shelter_registrations.create!(shelter_id: shelter.id)
  end

  # 避難所の登録のを解除する
  def shelter_unregistration!(shelter)
    shelter_registration = shelter_registrations.find_by!(shelter_id: shelter.id)

    shelter_registration.destroy
  end

  # 避難所を登録しているか
  def shelter_registerd?(shelter)
    shelter_registrations.exists?(shelter_id: shelter.id)
  end

  # 防災タスクプロフィールデータがあれば、データを返し、なければbuildする
  def prepare_task_profile
    task_profile || build_task_profile
  end

  # 家族ルールデータがあれば、データを返し、なければbuildする
  def prepare_family_rule
    family_rule || build_family_rule
  end

  # 家族ルールタスクを達成しているか
  def is_completed_family_rule_tasks?(user)
    FamilyRule.exists?(user_id: user.id)
  end
end
