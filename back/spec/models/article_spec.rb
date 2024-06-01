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
  # テスト内容（共通）
  shared_examples_for 'Valid' do
    it '保存できる' do
      expect(article).to be_valid
    end
  end
  shared_examples_for 'InValid' do
    it '保存できない' do
      expect(article).to be_invalid
    end
  end

  # タイトル
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 最大文字数と同じ, 最大文字数よりも多い
  describe 'validates :title' do
    let(:article) { FactoryBot.build_stubbed(:article, title: title) }

    # テストケース
    context 'ない' do
      let(:title) { nil }
      it_behaves_like 'InValid'
    end
    context '最大文字数と同じ' do
      let(:title) { 'a' * Settings['article_title_maximum'] }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:title) { 'a' * (Settings['article_title_maximum'] + 1) }
      it_behaves_like 'InValid'
    end
  end

  # 内容
  # 前提条件
  #   なし
  # テストパターン
  #   ない, ある
  describe 'validates :content' do
    let(:article) { FactoryBot.build_stubbed(:article, content: content) }

    # テストケース
    context 'ない' do
      let(:content) { nil }
      it_behaves_like 'InValid'
    end
    context 'ある' do
      let(:content) { 'content' }
      it_behaves_like 'Valid'
    end
  end

  # サムネイルURLを返却
  # 前提条件
  #   なし
  # テストパターン
  #   画像: ない, ある
  #   large, xlarge, xxlarge, 未定義
  describe '#thumbnail_url' do
    subject { article.thumbnail_url(version) }
    let(:article) { FactoryBot.create(:article, thumbnail: thumbnail) }

    # テスト内容
    shared_examples_for 'OK' do |version|
      let(:version) { version }
      it 'デフォルトではないURL' do
        is_expected.not_to be_blank
        is_expected.not_to include('_noimage.jpeg')
      end
    end
    shared_examples_for 'Def' do |version|
      let(:version) { version }
      it 'デフォルトのURL' do
        is_expected.to include('_noimage.jpeg')
      end
    end
    shared_examples_for 'Not' do |version|
      let(:version) { version }
      it 'URLが返却されない' do
        is_expected.to be_blank
      end
    end

    # テストケース
    context '画像がない' do
      let_it_be(:thumbnail) { nil }
      it_behaves_like 'Def', :large, true
      it_behaves_like 'Def', :xlarge, true
      it_behaves_like 'Def', :xxlarge, true
      it_behaves_like 'Not', nil
    end
    context '画像がある' do
      let_it_be(:thumbnail) { File.new(TEST_IMAGE_FILE) }
      let_it_be(:article)  { FactoryBot.create(:article, thumbnail: thumbnail) }
      it_behaves_like 'OK', :large, false
      it_behaves_like 'OK', :xlarge, false
      it_behaves_like 'OK', :xxlarge, false
      it_behaves_like 'Not', nil
    end
  end
end
