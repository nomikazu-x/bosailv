class Article < ApplicationRecord
  belongs_to :user

  has_many :article_favorites, dependent: :destroy
  has_many :article_comments, dependent: :destroy

  mount_uploader :thumbnail, ImageUploader

  flag :category, %i[gas watersuppry emergency knowledge earthquake tsunami volcano snow typhoon internalwater riverflood landslide strongwind heatstroke warning jalert]

  default_scope { order(created_at: :desc, id: :desc) }

  validates :title, presence: true
  validates :content, presence: true
  validates :category, presence: true

  # 画像URLを返却
  def thumbnail_url(version)
    case version
    when :large
      thumbnail? ? thumbnail.large.url : "/images/article/#{version}_noimage.jpeg"
    when :xlarge
      thumbnail? ? thumbnail.xlarge.url : "/images/article/#{version}_noimage.jpeg"
    when :xxlarge
      thumbnail? ? thumbnail.xxlarge.url : "/images/article/#{version}_noimage.jpeg"
    else
      logger.warn("[WARN]Not found: Article.thumbnail_url(#{version})")
      ''
    end
  end
end
