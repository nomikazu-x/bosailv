# == Schema Information
#
# Table name: article_genre_relations
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  article_id(記事ID)   :bigint           not null
#  genre_id(ジャンルID) :bigint           not null
#
# Indexes
#
#  index_article_genre_relations_on_article_id  (article_id)
#  index_article_genre_relations_on_genre_id    (genre_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (genre_id => genres.id)
#
require 'rails_helper'

RSpec.describe ArticleGenreRelation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
