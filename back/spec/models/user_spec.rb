# == Schema Information
#
# Table name: users
#
#  id                                                            :bigint           not null, primary key
#  allow_password_change(パスワード再設定中)                     :boolean          default(FALSE)
#  confirmation_sent_at(メールアドレス確認送信日時)              :datetime
#  confirmation_token(メールアドレス確認トークン)                :string(255)
#  confirmed_at(メールアドレス確認日時)                          :datetime
#  current_sign_in_at(現在のログイン日時)                        :datetime
#  current_sign_in_ip(現在のログインIPアドレス)                  :string(255)
#  email(メールアドレス)                                         :string(255)      default(""), not null
#  encrypted_password(認証方法)                                  :string(255)      default(""), not null
#  failed_attempts(連続ログイン失敗回数)                         :integer          default(0), not null
#  image(画像)                                                   :string(255)
#  infomation_check_last_started_at(お知らせ確認最終開始日時)    :datetime
#  last_sign_in_at(最終ログイン日時)                             :datetime
#  last_sign_in_ip(最終ログインIPアドレス)                       :string(255)
#  level(レベル)                                                 :integer          default(1), not null
#  lifelong_point(合計獲得ポイント)                              :integer          default(0), not null
#  locked_at(アカウントロック日時)                               :datetime
#  name(氏名)                                                    :string(30)       not null
#  point_to_next(現レベルにおける次のレベルまでに必要なポイント) :integer          default(5), not null
#  power(権限)                                                   :integer          default(NULL), not null
#  profile(自己紹介文)                                           :text(255)
#  provider(認証方法)                                            :string(255)      default("email"), not null
#  remember_created_at(ログイン状態維持開始日時)                 :datetime
#  reset_password_sent_at(パスワードリセット送信日時)            :datetime
#  reset_password_token(パスワードリセットトークン)              :string(255)
#  sign_in_count(ログイン回数)                                   :integer          default(0), not null
#  tokens(認証トークン)                                          :text(65535)
#  uid(UID)                                                      :string(255)      default(""), not null
#  unconfirmed_email(確認待ちメールアドレス)                     :string(255)
#  unlock_token(アカウントロック解除トークン)                    :string(255)
#  username(ユーザーネーム)                                      :string(30)       not null
#  created_at                                                    :datetime         not null
#  updated_at                                                    :datetime         not null
#  city_id(出身市区町村ID)                                       :integer
#  prefecture_id(出身都道府県ID)                                 :integer
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  # テスト内容（共通）
  shared_examples_for 'Valid' do
    it '保存できる' do
      expect(user).to be_valid
    end
  end
  shared_examples_for 'InValid' do
    it '保存できない' do
      expect(user).to be_invalid
    end
  end

  # ユーザーネーム
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 正常値, 重複
  describe 'validates :username' do
    let(:user) { FactoryBot.build_stubbed(:user, username: username) }
    let(:valid_username) { SecureRandom.alphanumeric(15) }

    # テストケース
    context 'ない' do
      let(:username) { nil }
      it_behaves_like 'InValid'
    end
    context '正常値' do
      let(:username) { valid_username }
      it_behaves_like 'Valid'
    end
    context '重複' do
      before { FactoryBot.create(:user, username: username) }
      let(:username) { valid_username }
      it_behaves_like 'InValid'
    end
  end

  # 氏名
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 最大文字数と同じ, 最大文字数よりも多い
  describe 'validates :name' do
    let(:user) { FactoryBot.build_stubbed(:user, name: name) }

    # テストケース
    context 'ない' do
      let(:name) { nil }
      it_behaves_like 'InValid'
    end
    context '最大文字数と同じ' do
      let(:name) { 'a' * Settings['user_name_maximum'] }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:name) { 'a' * (Settings['user_name_maximum'] + 1) }
      it_behaves_like 'InValid'
    end
  end

  # プロフィール
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 最大文字数と同じ, 最大文字数よりも多い
  describe 'validates :profile' do
    let(:user) { FactoryBot.build_stubbed(:user, profile: profile) }

    # テストケース
    context 'ない' do
      let(:profile) { nil }
      it_behaves_like 'Valid'
    end
    context '最大文字数と同じ' do
      let(:profile) { 'a' * Settings['user_profile_maximum'] }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:profile) { 'a' * (Settings['user_profile_maximum'] + 1) }
      it_behaves_like 'InValid'
    end
  end

  # 削除予約済みか返却
  # 前提条件
  #   なし
  # テストパターン
  #   削除予定日時: ない（予約なし）, ある（予約済み）
  describe '#destroy_reserved?' do
    subject { user.destroy_reserved? }
    let(:user) { FactoryBot.build_stubbed(:user, destroy_schedule_at: destroy_schedule_at) }

    context '削除予定日時がない（予約なし）' do
      let(:destroy_schedule_at) { nil }
      it 'false' do
        is_expected.to eq(false)
      end
    end
    context '削除予定日時がある（予約済み）' do
      let(:destroy_schedule_at) { Time.current }
      it 'true' do
        is_expected.to eq(true)
      end
    end
  end

  # 画像URLを返却
  # 前提条件
  #   なし
  # テストパターン
  #   画像: ない, ある
  #   mini, small, medium, large, xlarge, 未定義
  describe '#image_url' do
    subject { user.image_url(version) }
    let(:user) { FactoryBot.create(:user, image: image) }

    # テスト内容
    shared_examples_for 'OK' do |version|
      let(:version) { version }
      it 'デフォルトではないURL' do
        is_expected.not_to be_blank
        is_expected.not_to include('_noimage.jpg')
      end
    end
    shared_examples_for 'Def' do |version|
      let(:version) { version }
      it 'デフォルトのURL' do
        is_expected.to include('_noimage.jpg')
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
      let_it_be(:image) { nil }
      it_behaves_like 'Def', :mini, true
      it_behaves_like 'Def', :small, true
      it_behaves_like 'Def', :medium, true
      it_behaves_like 'Def', :large, true
      it_behaves_like 'Def', :xlarge, true
      it_behaves_like 'Not', nil
    end
    context '画像がある' do
      let_it_be(:image) { File.new(TEST_IMAGE_FILE) }
      let_it_be(:user)  { FactoryBot.create(:user, image: image) }
      it_behaves_like 'OK', :mini, false
      it_behaves_like 'OK', :small, false
      it_behaves_like 'OK', :medium, false
      it_behaves_like 'OK', :large, false
      it_behaves_like 'OK', :xlarge, false
      it_behaves_like 'Not', nil
    end
  end

  # お知らせの未読数を返却
  # 前提条件
  #   なし
  # テストパターン
  #   お知らせ対象: 0件, 1件（全員）, 1件（自分）, 2件（全員＋自分）
  #   お知らせ確認最終開始日時: ない, 過去, 現在
  describe '#infomation_unread_count' do
    subject { user.infomation_unread_count }
    let(:user) { FactoryBot.create(:user, infomation_check_last_started_at: infomation_check_last_started_at) }

    # テスト内容
    shared_examples_for 'Count' do |count|
      it "件数(#{count})" do
        is_expected.to eq(count)
      end
    end

    # テストケース
    shared_examples_for '[0件]お知らせ確認最終開始日時がない' do
      let(:infomation_check_last_started_at) { nil }
      it_behaves_like 'Count', 0
    end
    shared_examples_for '[1件]お知らせ確認最終開始日時がない' do
      let(:infomation_check_last_started_at) { nil }
      it_behaves_like 'Count', 1
    end
    shared_examples_for '[2件]お知らせ確認最終開始日時がない' do
      let(:infomation_check_last_started_at) { nil }
      it_behaves_like 'Count', 2
    end
    shared_examples_for '[0件]お知らせ確認最終開始日時が過去' do
      let(:infomation_check_last_started_at) { Time.current - 1.month }
      it_behaves_like 'Count', 0
    end
    shared_examples_for '[1件]お知らせ確認最終開始日時が過去' do
      let(:infomation_check_last_started_at) { Time.current - 1.month }
      it_behaves_like 'Count', 1
    end
    shared_examples_for '[2件]お知らせ確認最終開始日時が過去' do
      let(:infomation_check_last_started_at) { Time.current - 1.month }
      it_behaves_like 'Count', 2
    end
    shared_examples_for '[*]お知らせ確認最終開始日時が現在' do
      let(:infomation_check_last_started_at) { Time.current }
      it_behaves_like 'Count', 0
    end

    context 'お知らせ対象が0件' do
      include_context 'お知らせ一覧作成', 0, 0, 0, 0
      it_behaves_like '[0件]お知らせ確認最終開始日時がない'
      it_behaves_like '[0件]お知らせ確認最終開始日時が過去'
      it_behaves_like '[*]お知らせ確認最終開始日時が現在'
    end
    context 'お知らせ対象が1件（全員）' do
      include_context 'お知らせ一覧作成', 1, 0, 0, 0
      it_behaves_like '[1件]お知らせ確認最終開始日時がない'
      it_behaves_like '[1件]お知らせ確認最終開始日時が過去'
      it_behaves_like '[*]お知らせ確認最終開始日時が現在'
    end
    # context 'お知らせ対象が1件（自分）' do
    #   include_context 'お知らせ一覧作成', 0, 0, 1, 0
    #   it_behaves_like '[1件]お知らせ確認最終開始日時がない'
    #   it_behaves_like '[1件]お知らせ確認最終開始日時が過去'
    #   it_behaves_like '[*]お知らせ確認最終開始日時が現在'
    # end
    # context 'お知らせ対象が2件（全員＋自分）' do
    #   include_context 'お知らせ一覧作成', 0, 1, 0, 1
    #   it_behaves_like '[2件]お知らせ確認最終開始日時がない'
    #   it_behaves_like '[2件]お知らせ確認最終開始日時が過去'
    #   it_behaves_like '[*]お知らせ確認最終開始日時が現在'
    # end
  end

  # 記事をお気に入りしているかを返却
  # 前提条件
  #   なし
  # テストパターン
  #   記事をお気に入り: している, していない
  describe '#article_favorite?' do
    let_it_be(:article) { FactoryBot.create(:article) }
    let_it_be(:user)  { FactoryBot.create(:user) }
    subject { user.article_favorite?(article) }

    context '#article_favorite!' do
      it 'true' do
        user.article_favorite!(article)
        is_expected.to eq(true)
      end
    end
    context '#article_unfavorite!' do
      before { user.article_favorite!(article) }
      it 'false' do
        user.article_unfavorite!(article)
        is_expected.to eq(false)
      end
    end
  end

  # タスクを完了しているかを返却
  # 前提条件
  #   なし
  # テストパターン
  #   タスクを完了: している, していない
  describe '#task_complete?' do
    let_it_be(:task) { FactoryBot.create(:task) }
    let_it_be(:user)  { FactoryBot.create(:user) }
    subject { user.task_complete?(task) }

    context '#task_complete!' do
      it 'true' do
        user.task_complete!(task)
        is_expected.to eq(true)
      end
    end
    context '#task_uncomplete!' do
      before { user.task_complete!(task) }
      it 'false' do
        user.task_uncomplete!(task)
        is_expected.to eq(false)
      end
    end
  end

  # 避難所を登録しているかを返却
  # 前提条件
  #   なし
  # テストパターン
  #   避難所を登録: している, していない
  describe '#shelter_registerd?' do
    let_it_be(:shelter) { FactoryBot.create(:shelter) }
    let_it_be(:user)  { FactoryBot.create(:user) }
    subject { user.shelter_registerd?(shelter) }

    context '#shelter_registration!' do
      it 'true' do
        user.shelter_registration!(shelter)
        is_expected.to eq(true)
      end
    end
    context '#shelter_unregistration!' do
      before { user.shelter_registration!(shelter) }
      it 'false' do
        user.shelter_unregistration!(shelter)
        is_expected.to eq(false)
      end
    end
  end
end
