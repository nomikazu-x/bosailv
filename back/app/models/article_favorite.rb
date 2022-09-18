# == Schema Information
#
# Table name: article_favorites
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  article_id(記事ID)  :bigint           not null
#  user_id(ユーザーID) :bigint           not null
#
# Indexes
#
#  index_article_favorites_on_article_id              (article_id)
#  index_article_favorites_on_user_id                 (user_id)
#  index_article_favorites_on_user_id_and_article_id  (user_id,article_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
class ArticleFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :article

  validates :user_id, presence: true
  validates :article_id, presence: true
end
