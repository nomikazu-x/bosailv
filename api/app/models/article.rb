class Article < ApplicationRecord
  belongs_to :user

  has_many :article_favorites, dependent: :destroy
  has_many :article_comments, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
end
