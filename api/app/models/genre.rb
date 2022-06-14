class Genre < ApplicationRecord
  has_many :article_genre_relations
  has_many :articles, through: :article_genre_relations

  mount_uploader :image, ImageUploader
end
