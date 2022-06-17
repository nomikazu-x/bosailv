class Genre < ApplicationRecord
  has_many :article_genre_relations
  has_many :articles, through: :article_genre_relations

  mount_uploader :image, ImageUploader
  mount_uploader :icon, ImageUploader

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

  # 画像URLを返却
  def icon_url(version)
    case version
    when :mini
      icon? ? icon.mini.url : "/images/genre/icon/#{version}_noimage.jpg"
    when :small
      icon? ? icon.small.url : "/images/genre/icon/#{version}_noimage.jpg"
    when :medium
      icon? ? icon.medium.url : "/images/genre/icon/#{version}_noimage.jpg"
    when :large
      icon? ? icon.large.url : "/images/genre/icon/#{version}_noimage.jpg"
    when :xlarge
      icon? ? icon.xlarge.url : "/images/genre/icon/#{version}_noimage.jpg"
    else
      logger.warn("[WARN]Not found: Genre.icon_url(#{version})")
      ''
    end
  end
end
