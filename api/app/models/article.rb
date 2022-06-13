class Article < ApplicationRecord
  belongs_to :user

  has_many :article_favorites, dependent: :destroy
  has_many :article_comments, dependent: :destroy
  has_many :likers, through: :article_favorites, source: :user
  has_many :article_genre_relations
  has_many :genres, through: :article_genre_relations

  mount_uploader :thumbnail, ImageUploader

  default_scope { order(created_at: :desc, id: :desc) }

  validates :title, presence: true
  validates :content, presence: true

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
