# == Schema Information
#
# Table name: infomations
#
#  id                                   :bigint           not null, primary key
#  action(アクション)                   :string(255)
#  body(本文)                           :text(65535)
#  ended_at(終了日時)                   :datetime
#  force_ended_at(強制表示終了日時)     :datetime
#  force_started_at(強制表示開始日時)   :datetime
#  label(ラベル)                        :integer          default("Not"), not null
#  started_at(開始日時)                 :datetime         not null
#  summary(概要)                        :string(255)
#  target(対象)                         :integer          not null
#  title(タイトル)                      :string(255)      not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  action_user_id(アクションユーザーID) :bigint
#  article_id(記事ID)                   :bigint
#  user_id(ユーザーID)                  :bigint
#
# Indexes
#
#  index_infomations_on_article_id  (article_id)
#  index_infomations_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Infomation, type: :model do
  # 表示対象かを返却
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, ログイン中（削除予定あり）
  #   対象: 全員, 自分, 他人
  describe '#target_user?' do
    subject { infomation.target_user?(user) }
    let_it_be(:outside_user) { FactoryBot.create(:user) }

    # テスト内容
    shared_examples_for 'OK' do
      it 'true' do
        is_expected.to eq(true)
      end
    end
    shared_examples_for 'NG' do
      it 'false' do
        is_expected.to eq(false)
      end
    end

    # テストケース
    shared_examples_for '[*]対象が全員' do
      let_it_be(:infomation) { FactoryBot.create(:infomation, :all) }
      it_behaves_like 'OK'
    end
    shared_examples_for '[ログイン中/削除予定あり]対象が自分' do
      let_it_be(:infomation) { FactoryBot.create(:infomation, :user, user: user) }
      it_behaves_like 'OK'
    end
    shared_examples_for '[*]対象が他人' do
      let_it_be(:infomation) { FactoryBot.create(:infomation, :user, user: outside_user) }
      it_behaves_like 'NG'
    end

    context '未ログイン' do
      let(:user) { nil }
      it_behaves_like '[*]対象が全員'
      # it_behaves_like '[未ログイン]対象が自分' # NOTE: 未ログインの為、他人
      it_behaves_like '[*]対象が他人'
    end
    context 'ログイン中' do
      include_context 'ユーザー作成'
      it_behaves_like '[*]対象が全員'
      it_behaves_like '[ログイン中/削除予定あり]対象が自分'
      it_behaves_like '[*]対象が他人'
    end
    context 'ログイン中（削除予定あり）' do
      include_context 'ユーザー作成', :destroy_reserved
      it_behaves_like '[*]対象が全員'
      it_behaves_like '[ログイン中/削除予定あり]対象が自分'
      it_behaves_like '[*]対象が他人'
    end
  end

  # アクションに応じたタイトルを返却
  # 前提条件
  #   対象: 自分, ログイン中/削除予定あり
  # テストパターン
  #   ログイン中, ログイン中（削除予定あり） → データ作成
  #   アクションユーザー: いる, いない（削除済み） → 事前にデータ作成
  #   顧客: ある, ない（削除済み） → 事前にデータ作成
  #   アクション: ある(ArticleFavorite, ArticleComment), ない, 未定義 → データ作成
  describe 'action_title' do
    let!(:action_user) { FactoryBot.create(:user) }
    let!(:article) { FactoryBot.create(:article) }

    shared_context 'データ作成' do |action|
      let!(:infomation) do
        FactoryBot.create(:infomation, target: :user, user_id: user.id, action: action, action_user_id: action_user_id, article_id: article_id)
      end
    end

    # テスト内容
    shared_examples_for 'ToOK' do |key|
      it 'アクションのメッセージが返却される' do
        action_user_name = action_user_id.present? ? action_user.name : I18n.t('infomation.action_user.blank.name')
        article_title = article_id.present? ? article.title : I18n.t('infomation.article.blank.name')
        expect(infomation.action_title).to eq(I18n.t(key).gsub(/%{action_user_name}/, action_user_name)
                                                         .gsub(/%{article_title}/, article_title))
      end
    end
    shared_examples_for 'ToTitle' do
      it 'タイトルが返却される' do
        expect(infomation.action_title).to eq(infomation.title)
      end
    end
    shared_examples_for 'ToNG' do
      it 'ないが返却される' do
        expect(infomation.action_title).to eq(nil)
      end
    end

    # テストケース
    shared_examples_for '[*][*][*]アクションがある' do |action, key|
      include_context 'データ作成', action
      it_behaves_like 'ToOK', key
    end
    shared_examples_for '[*][*][*]アクションがない' do
      include_context 'データ作成', nil
      it_behaves_like 'ToTitle'
    end
    shared_examples_for '[*][*][*]アクションが未定義' do
      include_context 'データ作成', 'not'
      it_behaves_like 'ToNG'
    end

    shared_examples_for '[*][*]記事がある' do
      let!(:article_id) { article.id }
      it_behaves_like '[*][*][*]アクションがある', 'ArticleFavorite', 'infomation.action.article_favorite'
      it_behaves_like '[*][*][*]アクションがある', 'ArticleComment', 'infomation.action.article_comment'
      it_behaves_like '[*][*][*]アクションがない'
      it_behaves_like '[*][*][*]アクションが未定義'
    end
    shared_examples_for '[*][*]記事がない' do
      let!(:article_id) { nil }
      it_behaves_like '[*][*][*]アクションがある', 'ArticleFavorite', 'infomation.action.article_favorite'
      it_behaves_like '[*][*][*]アクションがある', 'ArticleComment', 'infomation.action.article_comment'
      it_behaves_like '[*][*][*]アクションがない'
      it_behaves_like '[*][*][*]アクションが未定義'
    end

    shared_examples_for '[*]アクションユーザーがいる' do
      let!(:action_user_id) { action_user.id }
      it_behaves_like '[*][*]記事がある'
      it_behaves_like '[*][*]記事がない'
    end
    shared_examples_for '[*]アクションユーザーがいない（削除済み）' do
      let!(:action_user_id) { nil }
      it_behaves_like '[*][*]記事がある'
      it_behaves_like '[*][*]記事がない'
    end

    context 'ログイン中' do
      let!(:user) { FactoryBot.create(:user) }
      it_behaves_like '[*]アクションユーザーがいる'
      it_behaves_like '[*]アクションユーザーがいない（削除済み）'
    end
    context 'ログイン中（削除予定あり）' do
      let!(:user) { FactoryBot.create(:user, destroy_schedule_at: Time.current + Settings['destroy_schedule_days'].days) }
      it_behaves_like '[*]アクションユーザーがいる'
      it_behaves_like '[*]アクションユーザーがいない（削除済み）'
    end
  end
end
