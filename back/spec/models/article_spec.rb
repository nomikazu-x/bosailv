# == Schema Information
#
# Table name: articles
#
#  id                        :bigint           not null, primary key
#  content(内容)             :text(4294967295) not null
#  thumbnail(サムネイル画像) :text(65535)
#  title(タイトル)           :string(30)       not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  user_id(ユーザーID)       :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "correct_article" do
    let(:user) { create(:user) }
    let(:article) { build(:article, user: user) }

    it "投稿が正しく作成されていること" do
      expect(article).to be_valid
    end
  end

  describe "validate length" do
    context "titleの長さが31文字以上の時" do
      let(:article) { build(:article, title: 'a' * 31) }
      it "エラーメッセージが返る" do
        article.valid?
        expect(article).to be_invalid
      end
    end
  end

  describe "validate presence" do
    context "titleがNULLの時" do
      let(:article) { build(:article, title: nil) }
      it "エラーメッセージが返る" do
        article.valid?
        expect(article).to be_invalid
      end
    end

    context "contentがNULLの時" do
      let(:article) { build(:article, content: nil) }
      it "エラーメッセージが返る" do
        article.valid?
        expect(article).to be_invalid
      end
    end

    context "userがNULLの時" do
      let(:article) { build(:article, user: nil) }
      it "エラーメッセージが返る" do
        article.valid?
        expect(article).to be_invalid
      end
    end
  end

  describe "association" do
    it "Userテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:user)
      expect(rel.macro).to eq :belongs_to
    end

    it "ArticleFavoriteテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:article_favorites)
      expect(rel.macro).to eq :has_many
      expect(rel.options[:dependent]).to eq :destroy
    end

    it "ArticleFavoriteテーブルを通じて、Likersを取得できること" do
      rel = described_class.reflect_on_association(:likers)
      expect(rel.macro).to eq :has_many
      expect(rel.options[:through]).to eq :article_favorites
      expect(rel.options[:source]).to eq :user
    end

    it "ArticleCommentテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:article_comments)
      expect(rel.macro).to eq :has_many
      expect(rel.options[:dependent]).to eq :destroy
    end

    it "ArticleGenreRelationテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:article_genre_relations)
      expect(rel.macro).to eq :has_many
      expect(rel.options[:dependent]).to eq :destroy
    end

    it "Genreテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:genres)
      expect(rel.macro).to eq :has_many
      expect(rel.options[:through]).to eq :article_genre_relations
    end
  end
end
