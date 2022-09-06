# == Schema Information
#
# Table name: genres
#
#  id                  :bigint           not null, primary key
#  description(説明文) :text(65535)      not null
#  image(画像)         :text(65535)      not null
#  name(ジャンル名)    :string(10)       not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Genre < ApplicationRecord
  has_many :article_genre_relations, dependent: :destroy
  has_many :articles, through: :article_genre_relations

  mount_uploader :image, ImageUploader

  validates :name, presence: true, length: { maximum: 10 }
  validates :description, presence: true
  validates :image, presence: true
  validates :icon, presence: true

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
