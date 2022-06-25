class Genre < ApplicationRecord
  has_many :article_genre_relations, dependent: :destroy
  has_many :articles, through: :article_genre_relations

  mount_uploader :image, ImageUploader

  # 画像URLを返却
  def image_url(version)
    case version
    when :large
      image? ? image.large.url : "/images/genre/image/#{version}_noimage.jpeg"
    when :xlarge
      image? ? image.xlarge.url : "/images/genre/image/#{version}_noimage.jpeg"
    when :xxlarge
      image? ? image.xxlarge.url : "/images/genre/image/#{version}_noimage.jpeg"
    else
      logger.warn("[WARN]Not found: Genre.image_url(#{version})")
      ''
    end
  end
end
