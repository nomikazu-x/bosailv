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
  describe "validates presence" do
    context "全カラムの値を指定しているとき" do
      let(:user) { create(:user) }

      it "userのレコードが作成される" do
        expect(user).to be_valid
      end
    end

    context "emailを指定していないとき" do
      let(:user) { build(:user, email: nil) }

      it "エラーになる" do
        user.valid?
        expect(user).to be_invalid
      end
    end

    context "passwordを指定していないとき" do
      let(:user) { build(:user, password: nil) }

      it "エラーになる" do
        user.valid?
        expect(user).to be_invalid
      end
    end
  end

  describe "validates uniqueness" do
    context "保存されたメールアドレスが指定されたとき" do
      let(:user1) { create(:user) }
      let(:user2) { build(:user, email: user1.email) }

      it "エラーになる" do
        user2.valid?
        expect(user2).to be_invalid
      end
    end

    context "保存されたユーザーネームが指定されたとき" do
      let(:user1) { create(:user) }
      let(:user2) { build(:user, username: user1.username) }

      it "エラーになる" do
        user2.valid?
        expect(user2).to be_invalid
      end
    end
  end

  describe "validates length" do
    context "パスワードが8文字未満の場合" do
      let(:user) { build(:user, password: 'aaaa') }
      it "エラーになる" do
        user.valid?
        expect(user).to be_invalid
      end
    end

    context "名前が31文字以上の場合" do
      let(:user) { build(:user, name: 'a' * 31) }
      it "エラーになる" do
        user.valid?
        expect(user).to be_invalid
      end
    end

    context "ユーザーネームが31文字以上の場合" do
      let(:user) { build(:user, username: 'a' * 31) }
      it "エラーになる" do
        user.valid?
        expect(user).to be_invalid
      end
    end
  end

  describe "validates regular expression" do
    context "パスワードが制御文字と半角を除いたASCII文字の場合" do
      let(:user) { build(:user, password: 'pass_*&^%word') }
      it "正常に保存できる" do
        expect(user).to be_valid
      end
    end

    context "パスワードが制御文字と半角を除いたASCII文字以外を含む場合" do
      let(:user) { build(:user, password: 'a' * 7 + 'あ') }
      it "エラーになる" do
        user.valid?
        expect(user).to be_invalid
      end
    end

    context "ユーザーネームが半角英数字とアンダーバーのみの場合" do
      let(:user) { create(:user) }
      it "正常に更新できる" do
        user.update(username: 'test_name')
        expect(user).to be_valid
      end
    end

    context "ユーザーネームが半角英数字とアンダーバー以外を含む場合" do
      let(:user) { create(:user) }
      it "正常に更新できない" do
        user.update(username: 'a' * 7 + 'あ')
        expect(user).to be_invalid
      end
    end
  end

  describe "association" do
    it "Articleテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:articles)
      expect(rel.macro).to eq :has_many
      expect(rel.options[:dependent]).to eq :destroy
    end

    it "Infomationテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:infomations)
      expect(rel.macro).to eq :has_many
      expect(rel.options[:dependent]).to eq :destroy
    end

    it "ArticleFavoriteテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:article_favorites)
      expect(rel.macro).to eq :has_many
      expect(rel.options[:dependent]).to eq :destroy
    end

    it "ArticleCommentテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:article_comments)
      expect(rel.macro).to eq :has_many
      expect(rel.options[:dependent]).to eq :destroy
    end

    it "PointRecordテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:point_records)
      expect(rel.macro).to eq :has_many
      expect(rel.options[:dependent]).to eq :destroy
    end

    it "ArticleFavoriteテーブルを通じて、お気に入りした記事一覧を取得できること" do
      rel = described_class.reflect_on_association(:favorited_articles)
      expect(rel.options[:through]).to eq :article_favorites
      expect(rel.options[:source]).to eq :article
    end

    it "TaskCompleteテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:task_completes)
      expect(rel.macro).to eq :has_many
    end
  end

  describe 'article_favorite/article_unfavorite/article_favorite? method' do
    let(:user) { create(:user) }
    let(:article) { create(:article, user: user) }

    context 'article_favoriteしていない状態の場合' do
      it '無効な状態であること' do
        expect(user.article_favorite?(article)).to eq false
      end
    end

    context 'article_favoriteした場合' do
      before do
        user.article_favorite!(article)
      end

      it 'article_favorite状態であること' do
        expect(user.article_favorite?(article)).to eq true
      end

      it 'article_unfavoriteすると無効な状態であること' do
        user.article_unfavorite!(article)
        expect(user.article_favorite?(article)).to eq false
      end
    end
  end

  describe 'task_complete/task_uncomplete/task_complete? method' do
    let(:user) { create(:user) }
    let(:task) { create(:task) }

    context 'task_completeしていない状態の場合' do
      it '無効な状態であること' do
        expect(user.task_complete?(task)).to eq false
      end
    end

    context 'task_completeした場合' do
      before do
        user.task_complete!(task)
      end

      it 'task_complete状態であること' do
        expect(user.task_complete?(task)).to eq true
      end

      it 'task_uncompleteすると無効な状態であること' do
        user.task_uncomplete!(task)
        expect(user.task_complete?(task)).to eq false
      end
    end
  end
end
