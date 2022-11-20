require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Passwords', type: :request do
  # テスト内容（共通）
  shared_examples_for 'ToMsg' do |error_class, errors_count, error_msg, message, alert, notice|
    it '対象のメッセージと一致する' do
      subject
      response_json = JSON.parse(response.body)
      msg = error_msg == 'Unauthorized' ? error_msg : I18n.t(error_msg)
      expect(response_json['errors'].to_s).to error_msg.present? ? include(msg) : be_blank
      expect(response_json['errors'].class).to eq(error_class)
      expect(response_json['errors']&.count).to errors_count.positive? ? eq(errors_count) : be_nil

      expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
      expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
    end
  end

  # GET /api/v1/auth/password パスワード再設定
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   トークン: 期限内（未ロック, ロック中, メール未確認）, 期限切れ, 存在しない, ない, 空
  #   ＋リダイレクトURL: ある, ない, ホワイトリストにない
  describe 'GET #edit' do
    subject do
      get edit_auth_password_path(format: :json, reset_password_token: reset_password_token, redirect_url: redirect_url),
          headers: auth_headers
    end

    # テスト内容
    shared_examples_for 'ToOK' do
      let(:redirect_url) { FRONT_SITE_URL }
      it '指定URL（成功パラメータ）にリダイレクトする' do
        is_expected.to redirect_to("#{FRONT_SITE_URL}?reset_password_token=#{reset_password_token}")
      end
    end
    shared_examples_for 'ToNG' do |alert, notice|
      let(:redirect_url) { FRONT_SITE_URL }
      it '指定URL（失敗パラメータ）にリダイレクトする' do
        param = { reset_password: false }
        param[:alert] = I18n.t(alert) if alert.present?
        param[:notice] = I18n.t(notice) if notice.present?
        is_expected.to redirect_to("#{FRONT_SITE_URL}?#{URI.encode_www_form(param.sort)}")
      end
    end

    shared_examples_for 'リダイレクトURLがない' do
      let(:redirect_url) { nil }
      it 'エラーページにリダイレクトする' do
        is_expected.to redirect_to(Settings['reset_password_error_url_not'])
      end
    end

    shared_examples_for 'リダイレクトURLがホワイトリストにない' do
      let(:redirect_url) { BAD_SITE_URL }
      it 'エラーページにリダイレクトする' do
        is_expected.to redirect_to(Settings['reset_password_error_url_bad'])
      end
    end

    # テストケース
    shared_examples_for '[*]トークンが期限内（未ロック）' do
      include_context 'パスワードリセットトークン作成', true
      it_behaves_like 'ToOK'
      it_behaves_like 'リダイレクトURLがない'
      it_behaves_like 'リダイレクトURLがホワイトリストにない'
    end

    shared_examples_for '[*]トークンが期限内（ロック中）' do
      include_context 'パスワードリセットトークン作成', true, true
      it_behaves_like 'ToOK'
      it_behaves_like 'リダイレクトURLがない'
      it_behaves_like 'リダイレクトURLがホワイトリストにない'
    end

    shared_examples_for '[*]トークンが期限内（メール未確認）' do
      include_context 'パスワードリセットトークン作成', true, false, true
      it_behaves_like 'ToOK'
      it_behaves_like 'リダイレクトURLがない'
      it_behaves_like 'リダイレクトURLがホワイトリストにない'
    end

    shared_examples_for '[*]トークンが期限切れ' do
      include_context 'パスワードリセットトークン作成', false
      it_behaves_like 'ToNG', 'activerecord.errors.models.user.attributes.reset_password_token.invalid', nil
      it_behaves_like 'リダイレクトURLがない'
      it_behaves_like 'リダイレクトURLがホワイトリストにない'
    end

    shared_examples_for '[*]トークンが存在しない' do
      let(:reset_password_token) { NOT_TOKEN }
      it_behaves_like 'ToNG', 'activerecord.errors.models.user.attributes.reset_password_token.invalid', nil
      it_behaves_like 'リダイレクトURLがない'
      it_behaves_like 'リダイレクトURLがホワイトリストにない'
    end

    shared_examples_for '[*]トークンがない' do
      let(:reset_password_token) { nil }
      it_behaves_like 'ToNG', 'activerecord.errors.models.user.attributes.reset_password_token.blank', nil
      it_behaves_like 'リダイレクトURLがない'
      it_behaves_like 'リダイレクトURLがホワイトリストにない'
    end

    shared_examples_for '[*]トークンが空' do
      let(:reset_password_token) { '' }
      it_behaves_like 'ToNG', 'activerecord.errors.models.user.attributes.reset_password_token.blank', nil
      it_behaves_like 'リダイレクトURLがない'
      it_behaves_like 'リダイレクトURLがホワイトリストにない'
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[*]トークンが期限内（未ロック）'
      it_behaves_like '[*]トークンが期限内（ロック中）'
      it_behaves_like '[*]トークンが期限内（メール未確認）'
      it_behaves_like '[*]トークンが期限切れ'
      it_behaves_like '[*]トークンが存在しない'
      it_behaves_like '[*]トークンがない'
      it_behaves_like '[*]トークンが空'
    end

    context 'ログイン中' do
      include_context 'ログイン処理'
      it_behaves_like '[*]トークンが期限内（未ロック）'
      it_behaves_like '[*]トークンが期限内（ロック中）'
      it_behaves_like '[*]トークンが期限内（メール未確認）'
      it_behaves_like '[*]トークンが期限切れ'
      it_behaves_like '[*]トークンが存在しない'
      it_behaves_like '[*]トークンがない'
      it_behaves_like '[*]トークンが空'
    end

    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[*]トークンが期限内（未ロック）'
      it_behaves_like '[*]トークンが期限内（ロック中）'
      it_behaves_like '[*]トークンが期限内（メール未確認）'
      it_behaves_like '[*]トークンが期限切れ'
      it_behaves_like '[*]トークンが存在しない'
      it_behaves_like '[*]トークンがない'
      it_behaves_like '[*]トークンが空'
    end
  end
end