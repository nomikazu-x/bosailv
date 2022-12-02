# == Schema Information
#
# Table content: article_comments
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
  # テスト内容（共通）
  shared_examples_for 'Valid' do
    it '保存できる' do
      expect(article_comment).to be_valid
    end
  end
  shared_examples_for 'InValid' do
    it '保存できない' do
      expect(article_comment).to be_invalid
    end
  end

  # 内容
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 最大文字数と同じ, 最大文字数よりも多い
  describe 'validates :content' do
    let(:article_comment) { FactoryBot.build_stubbed(:article_comment, content: content) }

    # テストケース
    context 'ない' do
      let(:content) { nil }
      it_behaves_like 'InValid'
    end
    context '最大文字数と同じ' do
      let(:content) { 'a' * Settings['article_comment_content_maximum'] }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:content) { 'a' * (Settings['article_comment_content_maximum'] + 1) }
      it_behaves_like 'InValid'
    end
  end
end
