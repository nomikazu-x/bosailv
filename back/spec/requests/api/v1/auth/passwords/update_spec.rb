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

  # POST /api/v1/auth/password/update(.json) パスワード再設定API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   トークン: 期限内（未ロック, ロック中, メール未確認, メールアドレス変更中）, 期限切れ, 存在しない, ない, 空
  #   パラメータなし, 有効なパラメータ, 無効なパラメータ（なし, 確認なし）
  describe 'POST #update' do
    subject { post update_auth_password_path(format: :json), params: attributes, headers: auth_headers }
    let(:new_password) { Faker::Internet.password(min_length: 8) }
    let(:valid_attributes)           { { reset_password_token: reset_password_token, password: new_password, password_confirmation: new_password } }
    let(:invalid_attributes)         { { reset_password_token: reset_password_token, password: nil, password_confirmation: nil } }
    let(:invalid_confirm_attributes) { { reset_password_token: reset_password_token, password: new_password, password_confirmation: nil } }
    include_context 'Authテスト内容'
    let(:current_user) { User.find(send_user.id) }

    # テスト内容
    shared_examples_for 'OK' do |change_confirmed = false|
      let!(:start_time) { Time.current.floor }
      it "パスワードリセット送信日時がなし#{'・メールアドレス確認日時が現在日時' if change_confirmed}に変更される。メールが送信される" do
        subject
        expect(current_user.reset_password_sent_at).to be_nil
        expect(current_user.confirmed_at).to change_confirmed ? be_between(start_time, Time.current) : eq(send_user.confirmed_at)
        expect(current_user.locked_at).to be_nil
        expect(current_user.failed_attempts).to eq(0)

        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(ActionMailer::Base.deliveries[0].subject).to eq(get_subject('devise.mailer.password_change.subject')) # パスワード変更完了のお知らせ
      end
    end

    shared_examples_for 'NG' do
      it 'パスワードリセット送信日時が変更されない。メールが送信されない' do
        subject
        expect(current_user.reset_password_sent_at).to eq(send_user.reset_password_sent_at)

        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end

    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。対象項目が一致する。認証ヘッダがある' do
        is_expected.to eq(200)
        expect_success_json
        expect_exist_auth_header
      end
    end

    shared_examples_for 'ToNG' do |code|
      it "HTTPステータスが#{code}。対象項目が一致する。認証ヘッダがない" do
        is_expected.to eq(code)
        expect_failure_json
        expect_not_exist_auth_header
      end
    end

    # テストケース
    shared_examples_for '[未ログイン/ログイン中][期限内/期限切れ]パラメータなし' do
      let(:attributes) { nil }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 400, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'errors.messages.validate_password_params', nil
    end

    shared_examples_for '[APIログイン中][期限内/期限切れ]パラメータなし' do
      let(:attributes) { nil }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 401, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    shared_examples_for '[未ログイン/ログイン中][存在しない/ない/空]パラメータなし' do
      let(:attributes) { nil }
      it_behaves_like 'ToNG', 400, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'errors.messages.validate_password_params', nil
    end

    shared_examples_for '[APIログイン中][存在しない/ない/空]パラメータなし' do
      let(:attributes) { nil }
      it_behaves_like 'ToNG', 401, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    shared_examples_for '[未ログイン/ログイン中][期限内]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'OK'
      it_behaves_like 'ToOK'
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, nil, 'devise_token_auth.passwords.successfully_updated'
    end

    shared_examples_for '[未ログイン/ログイン中][期限内（メール未確認）]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'OK', true
      it_behaves_like 'ToOK'
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, nil, 'devise_token_auth.passwords.successfully_updated'
    end

    shared_examples_for '[未ログイン/ログイン中][期限内（メールアドレス変更中）]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'OK'
      it_behaves_like 'ToOK'
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.unconfirmed', 'devise_token_auth.passwords.successfully_updated'
    end

    shared_examples_for '[APIログイン中][期限内/期限切れ]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 401, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    shared_examples_for '[未ログイン/ログイン中][期限切れ]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'activerecord.errors.models.user.attributes.reset_password_token.invalid', nil
    end

    shared_examples_for '[未ログイン/ログイン中][存在しない/ない/空]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToNG', 422, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'activerecord.errors.models.user.attributes.reset_password_token.invalid', nil
    end

    shared_examples_for '[APIログイン中][存在しない/空]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToNG', 401, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    shared_examples_for '[APIログイン中][ない]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToNG', 401, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    shared_examples_for '[未ログイン/ログイン中][期限内]無効なパラメータ（なし）' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422, false, false, false
      error_msg = 'activerecord.errors.models.user.attributes.password.blank'
      it_behaves_like 'ToMsg', Hash, 2, error_msg, nil, 'errors.messages.not_saved.one', nil
    end

    shared_examples_for '[APIログイン中][期限内/期限切れ]無効なパラメータ（なし）' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 401, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end
    shared_examples_for '[未ログイン/ログイン中][期限切れ]無効なパラメータ（なし）' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'activerecord.errors.models.user.attributes.reset_password_token.invalid', nil
    end

    shared_examples_for '[未ログイン/ログイン中][存在しない/ない/空]無効なパラメータ（なし）' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'ToNG', 422, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'activerecord.errors.models.user.attributes.reset_password_token.invalid', nil
    end

    shared_examples_for '[APIログイン中][存在しない/空]無効なパラメータ（なし）' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'ToNG', 401, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    shared_examples_for '[APIログイン中][ない]無効なパラメータ（なし）' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'ToNG', 401, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    shared_examples_for '[未ログイン/ログイン中][期限内]無効なパラメータ（確認なし）' do
      let(:attributes) { invalid_confirm_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422, false, false, false
      error_msg = 'activerecord.errors.models.user.attributes.password_confirmation.confirmation'
      it_behaves_like 'ToMsg', Hash, 2, error_msg, nil, 'errors.messages.not_saved.one', nil
    end

    shared_examples_for '[APIログイン中][期限内/期限切れ]無効なパラメータ（確認なし）' do
      let(:attributes) { invalid_confirm_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 401, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    shared_examples_for '[未ログイン/ログイン中][期限切れ]無効なパラメータ（確認なし）' do
      let(:attributes) { invalid_confirm_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'activerecord.errors.models.user.attributes.reset_password_token.invalid', nil
    end

    shared_examples_for '[未ログイン/ログイン中][存在しない/ない/空]無効なパラメータ（確認なし）' do
      let(:attributes) { invalid_confirm_attributes }
      it_behaves_like 'ToNG', 422, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'activerecord.errors.models.user.attributes.reset_password_token.invalid', nil
    end

    shared_examples_for '[APIログイン中][存在しない/空]無効なパラメータ（確認なし）' do
      let(:attributes) { invalid_confirm_attributes }
      it_behaves_like 'ToNG', 401, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    shared_examples_for '[APIログイン中][ない]無効なパラメータ（確認なし）' do
      let(:attributes) { invalid_confirm_attributes }
      it_behaves_like 'ToNG', 401, false, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    shared_examples_for '[未ログイン/ログイン中]トークンが期限内（未ロック）' do
      include_context 'パスワードリセットトークン作成', true
      it_behaves_like '[未ログイン/ログイン中][期限内/期限切れ]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中][期限内]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中][期限内]無効なパラメータ（なし）'
      it_behaves_like '[未ログイン/ログイン中][期限内]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[APIログイン中]トークンが期限内（未ロック）' do
      include_context 'パスワードリセットトークン作成', true
      it_behaves_like '[APIログイン中][期限内/期限切れ]パラメータなし'
      it_behaves_like '[APIログイン中][期限内/期限切れ]有効なパラメータ'
      it_behaves_like '[APIログイン中][期限内/期限切れ]無効なパラメータ（なし）'
      it_behaves_like '[APIログイン中][期限内/期限切れ]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[未ログイン/ログイン中]トークンが期限内（ロック中）' do
      include_context 'パスワードリセットトークン作成', true, true
      it_behaves_like '[未ログイン/ログイン中][期限内/期限切れ]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中][期限内]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中][期限内]無効なパラメータ（なし）'
      it_behaves_like '[未ログイン/ログイン中][期限内]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[APIログイン中]トークンが期限内（ロック中）' do
      include_context 'パスワードリセットトークン作成', true, true
      it_behaves_like '[APIログイン中][期限内/期限切れ]パラメータなし'
      it_behaves_like '[APIログイン中][期限内/期限切れ]有効なパラメータ'
      it_behaves_like '[APIログイン中][期限内/期限切れ]無効なパラメータ（なし）'
      it_behaves_like '[APIログイン中][期限内/期限切れ]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[未ログイン/ログイン中]トークンが期限内（メール未確認）' do
      include_context 'パスワードリセットトークン作成', true, false, true
      it_behaves_like '[未ログイン/ログイン中][期限内/期限切れ]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中][期限内（メール未確認）]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中][期限内]無効なパラメータ（なし）'
      it_behaves_like '[未ログイン/ログイン中][期限内]無効なパラメータ（確認なし）'
    end
    shared_examples_for '[APIログイン中]トークンが期限内（メール未確認）' do
      include_context 'パスワードリセットトークン作成', true, false, true
      it_behaves_like '[APIログイン中][期限内/期限切れ]パラメータなし'
      it_behaves_like '[APIログイン中][期限内/期限切れ]有効なパラメータ'
      it_behaves_like '[APIログイン中][期限内/期限切れ]無効なパラメータ（なし）'
      it_behaves_like '[APIログイン中][期限内/期限切れ]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[未ログイン/ログイン中]トークンが期限内（メールアドレス変更中）' do
      include_context 'パスワードリセットトークン作成', true, false, true, true
      it_behaves_like '[未ログイン/ログイン中][期限内/期限切れ]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中][期限内（メールアドレス変更中）]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中][期限内]無効なパラメータ（なし）'
      it_behaves_like '[未ログイン/ログイン中][期限内]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[APIログイン中]トークンが期限内（メールアドレス変更中）' do
      include_context 'パスワードリセットトークン作成', true, false, true, true
      it_behaves_like '[APIログイン中][期限内/期限切れ]パラメータなし'
      it_behaves_like '[APIログイン中][期限内/期限切れ]有効なパラメータ'
      it_behaves_like '[APIログイン中][期限内/期限切れ]無効なパラメータ（なし）'
      it_behaves_like '[APIログイン中][期限内/期限切れ]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[未ログイン/ログイン中]トークンが期限切れ' do
      include_context 'パスワードリセットトークン作成', false
      it_behaves_like '[未ログイン/ログイン中][期限内/期限切れ]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中][期限切れ]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中][期限切れ]無効なパラメータ（なし）'
      it_behaves_like '[未ログイン/ログイン中][期限切れ]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[APIログイン中]トークンが期限切れ' do
      include_context 'パスワードリセットトークン作成', false
      it_behaves_like '[APIログイン中][期限内/期限切れ]パラメータなし'
      it_behaves_like '[APIログイン中][期限内/期限切れ]有効なパラメータ'
      it_behaves_like '[APIログイン中][期限内/期限切れ]無効なパラメータ（なし）'
      it_behaves_like '[APIログイン中][期限内/期限切れ]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[未ログイン/ログイン中]トークンが存在しない' do
      let(:reset_password_token) { NOT_TOKEN }
      it_behaves_like '[未ログイン/ログイン中][存在しない/ない/空]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中][存在しない/ない/空]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中][存在しない/ない/空]無効なパラメータ（なし）'
      it_behaves_like '[未ログイン/ログイン中][存在しない/ない/空]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[APIログイン中]トークンが存在しない' do
      let(:reset_password_token) { NOT_TOKEN }
      it_behaves_like '[APIログイン中][存在しない/ない/空]パラメータなし'
      it_behaves_like '[APIログイン中][存在しない/空]有効なパラメータ'
      it_behaves_like '[APIログイン中][存在しない/空]無効なパラメータ（なし）'
      it_behaves_like '[APIログイン中][存在しない/空]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[未ログイン/ログイン中]トークンがない' do
      let(:reset_password_token) { nil }
      it_behaves_like '[未ログイン/ログイン中][存在しない/ない/空]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中][存在しない/ない/空]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中][存在しない/ない/空]無効なパラメータ（なし）'
      it_behaves_like '[未ログイン/ログイン中][存在しない/ない/空]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[APIログイン中]トークンがない' do
      let(:reset_password_token) { nil }
      it_behaves_like '[APIログイン中][存在しない/ない/空]パラメータなし'
      it_behaves_like '[APIログイン中][ない]有効なパラメータ'
      it_behaves_like '[APIログイン中][ない]無効なパラメータ（なし）'
      it_behaves_like '[APIログイン中][ない]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[未ログイン/ログイン中]トークンが空' do
      let(:reset_password_token) { '' }
      it_behaves_like '[未ログイン/ログイン中][存在しない/ない/空]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中][存在しない/ない/空]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中][存在しない/ない/空]無効なパラメータ（なし）'
      it_behaves_like '[未ログイン/ログイン中][存在しない/ない/空]無効なパラメータ（確認なし）'
    end

    shared_examples_for '[APIログイン中]トークンが空' do
      let(:reset_password_token) { '' }
      it_behaves_like '[APIログイン中][存在しない/ない/空]パラメータなし'
      it_behaves_like '[APIログイン中][存在しない/空]有効なパラメータ'
      it_behaves_like '[APIログイン中][存在しない/空]無効なパラメータ（なし）'
      it_behaves_like '[APIログイン中][存在しない/空]無効なパラメータ（確認なし）'
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]トークンが期限内（未ロック）'
      it_behaves_like '[未ログイン/ログイン中]トークンが期限内（ロック中）'
      it_behaves_like '[未ログイン/ログイン中]トークンが期限内（メール未確認）'
      it_behaves_like '[未ログイン/ログイン中]トークンが期限内（メールアドレス変更中）'
      it_behaves_like '[未ログイン/ログイン中]トークンが期限切れ'
      it_behaves_like '[未ログイン/ログイン中]トークンが存在しない'
      it_behaves_like '[未ログイン/ログイン中]トークンがない'
      it_behaves_like '[未ログイン/ログイン中]トークンが空'
    end

    context 'ログイン中' do
      include_context 'ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]トークンが期限内（未ロック）'
      it_behaves_like '[未ログイン/ログイン中]トークンが期限内（ロック中）'
      it_behaves_like '[未ログイン/ログイン中]トークンが期限内（メール未確認）'
      it_behaves_like '[未ログイン/ログイン中]トークンが期限内（メールアドレス変更中）'
      it_behaves_like '[未ログイン/ログイン中]トークンが期限切れ'
      it_behaves_like '[未ログイン/ログイン中]トークンが存在しない'
      it_behaves_like '[未ログイン/ログイン中]トークンがない'
      it_behaves_like '[未ログイン/ログイン中]トークンが空'
    end
    
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[APIログイン中]トークンが期限内（未ロック）'
      it_behaves_like '[APIログイン中]トークンが期限内（ロック中）'
      it_behaves_like '[APIログイン中]トークンが期限内（メール未確認）'
      it_behaves_like '[APIログイン中]トークンが期限内（メールアドレス変更中）'
      it_behaves_like '[APIログイン中]トークンが期限切れ'
      it_behaves_like '[APIログイン中]トークンが存在しない'
      it_behaves_like '[APIログイン中]トークンがない'
      it_behaves_like '[APIログイン中]トークンが空'
    end
  end
end