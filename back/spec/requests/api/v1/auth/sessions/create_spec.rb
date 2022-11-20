require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Sessions', type: :request do
  # テスト内容（共通）
  shared_examples_for 'ToMsg' do |error_msg, alert, notice|
    it '対象のメッセージと一致する' do
      subject
      response_json = JSON.parse(response.body)

      expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
      expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
    end
  end

  # POST /api/v1/auth/sign_in(.json) ログインAPI(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中, APIログイン中（削除予約済み）
  #   パラメータなし, 有効なパラメータ（未ロック, ロック中, メール未確認, メールアドレス変更中, 削除予約済み）, 無効なパラメータ（存在しない, ロック前, ロック前の前, ロック前の前の前）, URLがない, URLがホワイトリストにない
  describe 'POST #create' do
    subject { post create_auth_session_path(format: :json), params: attributes, headers: auth_headers }
    let_it_be(:send_user_unlocked)         { FactoryBot.create(:user) }
    let_it_be(:send_user_locked)           { FactoryBot.create(:user, :locked) }
    let_it_be(:send_user_unconfirmed)      { FactoryBot.create(:user, :unconfirmed) }
    let_it_be(:send_user_email_changed)    { FactoryBot.create(:user, :email_changed) }
    let_it_be(:send_user_destroy_reserved) { FactoryBot.create(:user, :destroy_reserved) }
    let_it_be(:not_user)                   { FactoryBot.attributes_for(:user) }
    let_it_be(:send_user_before_lock1)     { FactoryBot.create(:user, :before_lock1) }
    let_it_be(:send_user_before_lock2)     { FactoryBot.create(:user, :before_lock2) }
    let_it_be(:send_user_before_lock3)     { FactoryBot.create(:user, :before_lock3) }
    let(:valid_attributes)        { { email: send_user.email, password: send_user.password, unlock_redirect_url: FRONT_SITE_URL } }
    let(:invalid_not_attributes)  { { email: not_user[:email], password: not_user[:password], unlock_redirect_url: FRONT_SITE_URL } }
    let(:invalid_pass_attributes) { { email: send_user.email, password: "n#{send_user.password}", unlock_redirect_url: FRONT_SITE_URL } }
    let(:invalid_nil_attributes)  { { email: send_user.email, password: send_user.password, unlock_redirect_url: nil } }
    let(:invalid_bad_attributes)  { { email: send_user.email, password: send_user.password, unlock_redirect_url: BAD_SITE_URL } }
    include_context 'Authテスト内容'
    let(:current_user) { User.find(send_user.id) }

    # テスト内容
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

    shared_examples_for 'SendLocked' do
      let(:url) { "http://#{Settings['base_domain']}#{user_auth_unlock_path}" }
      let(:url_param) { "redirect_url=#{URI.encode_www_form_component(attributes[:unlock_redirect_url])}" }
      it 'メールが送信される' do
        subject
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(ActionMailer::Base.deliveries[0].subject).to eq(get_subject('devise.mailer.unlock_instructions.subject')) # アカウントロックのお知らせ
      end
    end
    shared_examples_for 'NotSendLocked' do
      it 'メールが送信されない' do
        expect { subject }.to change(ActionMailer::Base.deliveries, :count).by(0)
      end
    end

    # テストケース
    shared_examples_for '[未ログイン/ログイン中]パラメータなし' do
      let(:attributes) { nil }
      it_behaves_like 'ToNG', 400
      it_behaves_like 'ToMsg', nil, 'devise_token_auth.sessions.bad_credentials', nil
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[APIログイン中/削除予約済み]パラメータなし' do
      let(:attributes) { nil }
      it_behaves_like 'ToNG', 400
      it_behaves_like 'ToMsg', nil, 'devise_token_auth.sessions.bad_credentials', nil
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ（未ロック）' do
      let(:send_user)  { send_user_unlocked }
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToOK', true, false
      it_behaves_like 'ToMsg', nil, nil, 'devise.sessions.signed_in'
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[APIログイン中/削除予約済み]有効なパラメータ（未ロック）' do
      let(:send_user)  { send_user_unlocked }
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToOK', true, false
      it_behaves_like 'ToMsg', nil, nil, 'devise.sessions.signed_in'
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ（ロック中）' do
      let(:send_user)  { send_user_locked }
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', nil, 'devise.failure.locked', nil
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[APIログイン中/削除予約済み]有効なパラメータ（ロック中）' do
      let(:send_user)  { send_user_locked }
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', nil, 'devise.failure.locked', nil
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ（メール未確認）' do
      let(:send_user)  { send_user_unconfirmed }
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', nil, 'devise.failure.unconfirmed', nil
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[APIログイン中/削除予約済み]有効なパラメータ（メール未確認）' do
      let(:send_user)  { send_user_unconfirmed }
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', nil, 'devise.failure.unconfirmed', nil
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ（メールアドレス変更中）' do
      let(:send_user)  { send_user_email_changed }
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToOK', true, false
      it_behaves_like 'ToMsg', nil, nil, 'devise.sessions.signed_in'
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[APIログイン中/削除予約済み]有効なパラメータ（メールアドレス変更中）' do
      let(:send_user)  { send_user_email_changed }
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToOK', true, false
      it_behaves_like 'ToMsg', nil, nil, 'devise.sessions.signed_in'
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ（削除予約済み）' do
      let(:send_user)  { send_user_destroy_reserved }
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToOK', true, false
      it_behaves_like 'ToMsg', nil, nil, 'devise.sessions.signed_in'
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[APIログイン中/削除予約済み]有効なパラメータ（削除予約済み）' do
      let(:send_user)  { send_user_destroy_reserved }
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToOK', true, false
      it_behaves_like 'ToMsg', nil, nil, 'devise.sessions.signed_in'
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[未ログイン/ログイン中]無効なパラメータ（存在しない）' do
      let(:attributes) { invalid_not_attributes }
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', nil, 'devise.failure.invalid', nil
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[APIログイン中/削除予約済み]無効なパラメータ（存在しない）' do
      let(:attributes) { invalid_not_attributes }
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', nil, 'devise.failure.invalid', nil
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[*]無効なパラメータ（ロック前）' do
      let(:send_user)  { send_user_before_lock1 }
      let(:attributes) { invalid_pass_attributes }
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', nil, 'devise.failure.send_locked', nil
      it_behaves_like 'SendLocked'
    end
    shared_examples_for '[*]無効なパラメータ（ロック前の前）' do
      let(:send_user)  { send_user_before_lock2 }
      let(:attributes) { invalid_pass_attributes }
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', nil, 'devise.failure.last_attempt', nil
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[*]無効なパラメータ（ロック前の前の前）' do
      let(:send_user)  { send_user_before_lock3 }
      let(:attributes) { invalid_pass_attributes }
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', nil, 'devise.failure.invalid', nil
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[*]URLがない' do
      let(:send_user)  { send_user_unlocked }
      let(:attributes) { invalid_nil_attributes }
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', nil, 'devise_token_auth.sessions.unlock_redirect_url_blank', nil
      it_behaves_like 'NotSendLocked'
    end
    shared_examples_for '[*]URLがホワイトリストにない' do
      let(:send_user)  { send_user_unlocked }
      let(:attributes) { invalid_bad_attributes }
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', nil, 'devise_token_auth.sessions.unlock_redirect_url_not_allowed', nil
      it_behaves_like 'NotSendLocked'
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ（未ロック）'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ（ロック中）'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ（メール未確認）'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ（メールアドレス変更中）'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ（削除予約済み）'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ（存在しない）'
      it_behaves_like '[*]無効なパラメータ（ロック前）'
      it_behaves_like '[*]無効なパラメータ（ロック前の前）'
      it_behaves_like '[*]無効なパラメータ（ロック前の前の前）'
      it_behaves_like '[*]URLがない'
      it_behaves_like '[*]URLがホワイトリストにない'
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ（未ロック）'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ（ロック中）'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ（メール未確認）'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ（メールアドレス変更中）'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ（削除予約済み）'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ（存在しない）'
      it_behaves_like '[*]無効なパラメータ（ロック前）'
      it_behaves_like '[*]無効なパラメータ（ロック前の前）'
      it_behaves_like '[*]無効なパラメータ（ロック前の前の前）'
      it_behaves_like '[*]URLがない'
      it_behaves_like '[*]URLがホワイトリストにない'
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[APIログイン中/削除予約済み]パラメータなし'
      it_behaves_like '[APIログイン中/削除予約済み]有効なパラメータ（未ロック）'
      it_behaves_like '[APIログイン中/削除予約済み]有効なパラメータ（ロック中）'
      it_behaves_like '[APIログイン中/削除予約済み]有効なパラメータ（メール未確認）'
      it_behaves_like '[APIログイン中/削除予約済み]有効なパラメータ（メールアドレス変更中）'
      it_behaves_like '[APIログイン中/削除予約済み]有効なパラメータ（削除予約済み）'
      it_behaves_like '[APIログイン中/削除予約済み]無効なパラメータ（存在しない）'
      it_behaves_like '[*]無効なパラメータ（ロック前）'
      it_behaves_like '[*]無効なパラメータ（ロック前の前）'
      it_behaves_like '[*]無効なパラメータ（ロック前の前の前）'
      it_behaves_like '[*]URLがない'
      it_behaves_like '[*]URLがホワイトリストにない'
    end
    context 'APIログイン中（削除予約済み）' do
      include_context 'APIログイン処理', :destroy_reserved
      it_behaves_like '[APIログイン中/削除予約済み]パラメータなし'
      it_behaves_like '[APIログイン中/削除予約済み]有効なパラメータ（未ロック）'
      it_behaves_like '[APIログイン中/削除予約済み]有効なパラメータ（ロック中）'
      it_behaves_like '[APIログイン中/削除予約済み]有効なパラメータ（メール未確認）'
      it_behaves_like '[APIログイン中/削除予約済み]有効なパラメータ（メールアドレス変更中）'
      it_behaves_like '[APIログイン中/削除予約済み]有効なパラメータ（削除予約済み）'
      it_behaves_like '[APIログイン中/削除予約済み]無効なパラメータ（存在しない）'
      it_behaves_like '[*]無効なパラメータ（ロック前）'
      it_behaves_like '[*]無効なパラメータ（ロック前の前）'
      it_behaves_like '[*]無効なパラメータ（ロック前の前の前）'
      it_behaves_like '[*]URLがない'
      it_behaves_like '[*]URLがホワイトリストにない'
    end
  end
end