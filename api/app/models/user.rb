# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable
  include DeviseTokenAuth::Concerns::User

  mount_uploader :image, ImageUploader

  has_many :articles, dependent: :destroy
  has_many :infomations, dependent: :destroy
  has_many :article_favorites, dependent: :destroy
  has_many :article_comments, dependent: :destroy

  VALID_USERNAME_REGEX = /\A[\w_]+\z/i
  VALID_PASSWORD_REGEX = /\A[!-~]+\z/

  validates :name, length: { maximum: 50 }
  validates :password, presence: true, format: { with: VALID_PASSWORD_REGEX }, allow_nil: true

  # 画像URLを返却
  def image_url(version)
    case version
    when :mini
      image? ? image.mini.url : "/images/user/#{version}_noimage.jpg"
    when :small
      image? ? image.small.url : "/images/user/#{version}_noimage.jpg"
    when :medium
      image? ? image.medium.url : "/images/user/#{version}_noimage.jpg"
    when :large
      image? ? image.large.url : "/images/user/#{version}_noimage.jpg"
    when :xlarge
      image? ? image.xlarge.url : "/images/user/#{version}_noimage.jpg"
    else
      logger.warn("[WARN]Not found: User.image_url(#{version})")
      ''
    end
  end

  def infomation_unread_count
    Infomation.by_target(self).by_unread(infomation_check_last_started_at).count
  end

  def article_favorite!(article)
    article_favorites.create!(article_id: article.id)
  end

  def article_unfavorite!(article)
    article_favorite = article_favorites.find_by!(article_id: article.id)

    article_favorite.destroy
  end

  def article_favorite?(article)
    article_favorites.exists?(article_id: article.id)
  end
end
