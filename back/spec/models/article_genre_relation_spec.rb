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
  describe "correct_article_genre_relation" do
    let(:genre) { create(:genre) }
    let(:article) { create(:article) }
    let(:article_genre_relation) { build(:article_genre_relation, article: article, genre: genre) }

    it "データが正しく作成されていること" do
      expect(article_genre_relation).to be_valid
    end
  end

  describe "validate presence" do
    context "genreがNULLの時" do
      let(:article_genre_relation) { build(:article_genre_relation, genre: nil) }
      it "エラーメッセージが返る" do
        article_genre_relation.valid?
        expect(article_genre_relation).to be_invalid
      end
    end

    context "articleがNULLの時" do
      let(:article_genre_relation) { build(:article_genre_relation, article: nil) }
      it "エラーメッセージが返る" do
        article_genre_relation.valid?
        expect(article_genre_relation).to be_invalid
      end
    end
  end

  describe "association" do
    it "genreテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:genre)
      expect(rel.macro).to eq :belongs_to
    end

    it "Articleテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:article)
      expect(rel.macro).to eq :belongs_to
    end
  end
end
