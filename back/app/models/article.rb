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
  has_many :genres, through: :article_genre_relations, validate: false

  mount_uploader :thumbnail, ImageUploader

  default_scope { order(created_at: :desc, id: :desc) }
  # お気に入り数の多い順に一覧を取得
  scope :by_favorite_count_ranking, lambda { |famous|
    return unless famous

    article = all
    article = article.joins(:article_favorites).group(:id).order('count(article_favorites.article_id) desc', id: :desc)
    article
  }
  # 執筆記事かマイ記事一覧を取得
  scope :by_target, lambda { |user, favorite|
    return if user.blank?

    article = favorite ? user.favorited_articles : user.articles

    article
  }
  # キーワードを含む記事一覧を取得
  scope :search_keyword, lambda { |keyword|
    return if keyword&.strip.blank?

    article = all
    keyword.split(/[[:blank:]]+/).each do |word|
      value = "%#{word}%"
      article = article.where("title LIKE ? OR content LIKE ?", value, value)
    end

    article
  }
  # 選択されたジャンルと関連する記事一覧を取得
  scope :search_genre, lambda { |genre_ids|
    return if genre_ids.blank?

    article = all
    article = article.joins(:article_genre_relations).merge(ArticleGenreRelation.where(genre_id: genre_ids)).group('article_genre_relations.article_id').having('count(articles.id) = ?', genre_ids.length)
    article
  }

  validates :title, presence: true
  validates :title, length: { maximum: Settings['article_title_maximum'] }
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
