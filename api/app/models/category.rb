class Category < ApplicationRecord
  has_many :article_category_relations
  has_many :articles, through: :article_category_relations, dependent: :destroy
end
