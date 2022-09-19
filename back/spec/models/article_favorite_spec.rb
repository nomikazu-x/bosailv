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
require 'rails_helper'

RSpec.describe ArticleFavorite, type: :model do
  describe "correct_article_favorite" do
    let(:user) { create(:user) }
    let(:article) { create(:article, user: user) }
    let(:article_favorite) { build(:article_favorite, article: article, user: user) }

    it "データが正しく作成されていること" do
      expect(article_favorite).to be_valid
    end
  end

  describe "validate presence" do
    context "userがNULLの時" do
      let(:article_favorite) { build(:article_favorite, user: nil) }
      it "エラーメッセージが返る" do
        article_favorite.valid?
        expect(article_favorite).to be_invalid
      end
    end

    context "articleがNULLの時" do
      let(:article_favorite) { build(:article_favorite, article: nil) }
      it "エラーメッセージが返る" do
        article_favorite.valid?
        expect(article_favorite).to be_invalid
      end
    end
  end

  describe "association" do
    it "Userテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:user)
      expect(rel.macro).to eq :belongs_to
    end

    it "Articleテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:article)
      expect(rel.macro).to eq :belongs_to
    end
  end
end
