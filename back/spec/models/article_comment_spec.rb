# == Schema Information
#
# Table name: article_comments
#
#  id                  :bigint           not null, primary key
#  content(内容)       :text(255)        not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  article_id(記事ID)  :bigint           not null
#  user_id(ユーザーID) :bigint           not null
#
# Indexes
#
#  index_article_comments_on_article_id  (article_id)
#  index_article_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe ArticleComment, type: :model do
  describe "correct_article_comment" do
    let(:user) { create(:user) }
    let(:article) { create(:article, user: user) }
    let(:article_comment) { build(:article_comment, article: article, user: user) }

    it "コメントが正しく作成されていること" do
      expect(article_comment).to be_valid
    end
  end

  describe "validate length" do
    context "contentの長さが256文字以上の時" do
      let(:article_comment) { build(:article_comment, content: 'a' * 256) }
      it "エラーメッセージが返る" do
        article_comment.valid?
        expect(article_comment).to be_invalid
      end
    end
  end

  describe "validate presence" do
    context "contentがNULLの時" do
      let(:article_comment) { build(:article_comment, content: nil) }
      it "エラーメッセージが返る" do
        article_comment.valid?
        expect(article_comment).to be_invalid
      end
    end

    context "userがNULLの時" do
      let(:article_comment) { build(:article_comment, user: nil) }
      it "エラーメッセージが返る" do
        article_comment.valid?
        expect(article_comment).to be_invalid
      end
    end

    context "articleがNULLの時" do
      let(:article_comment) { build(:article_comment, article: nil) }
      it "エラーメッセージが返る" do
        article_comment.valid?
        expect(article_comment).to be_invalid
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
