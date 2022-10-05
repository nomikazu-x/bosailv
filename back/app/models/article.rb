# == Schema Information
#
# Table name: articles
#
#  id                        :bigint           not null, primary key
#  content(内容)             :text(4294967295) not null
#  thumbnail(サムネイル画像) :text(65535)
#  title(タイトル)           :string(30)       not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  user_id(ユーザーID)       :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Article < ApplicationRecord
  belongs_to :user

  has_many :article_favorites, dependent: :destroy
  has_many :article_comments, dependent: :destroy
  has_many :likers, through: :article_favorites, source: :user
  has_many :article_genre_relations, dependent: :destroy
  has_many :genres, through: :article_genre_relations

  mount_uploader :thumbnail, ImageUploader

  default_scope { order(created_at: :desc, id: :desc) }

  scope :ranking, -> { joins(:article_favorites).group(:id).order('count(article_favorites.article_id) desc', id: :desc) }

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true

  # 画像URLを返却
  def thumbnail_url(version)
    case version
    when :large
      thumbnail? ? thumbnail.large.url : "#{Settings['base_image_url']}/images/article/#{version}_noimage.jpeg"
    when :xlarge
      thumbnail? ? thumbnail.xlarge.url : "#{Settings['base_image_url']}/images/article/#{version}_noimage.jpeg"
    when :xxlarge
      thumbnail? ? thumbnail.xxlarge.url : "#{Settings['base_image_url']}/images/article/#{version}_noimage.jpeg"
    else
      logger.warn("[WARN]Not found: Article.thumbnail_url(#{version})")
      ''
    end
  end

end
