class Article < ApplicationRecord
  belongs_to :user

  has_many :article_favorites, dependent: :destroy
  has_many :article_comments, dependent: :destroy
  has_many :article_category_relations
  has_many :categories, through: :article_category_relations, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
end
