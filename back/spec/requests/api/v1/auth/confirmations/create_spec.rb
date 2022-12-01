require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Confirmations', type: :request do
  # テスト内容（共通）
  shared_examples_for 'ToMsg' do |error_class, errors_count, error_msg, message, alert, notice|
    it '対象のメッセージと一致する' do
      subject
      response_json = JSON.parse(response.body)
      expect(response_json['errors'].to_s).to error_msg.present? ? include(I18n.t(error_msg)) : be_blank
      expect(response_json['errors'].class).to eq(error_class) 
      expect(response_json['errors']&.count).to errors_count.positive? ? eq(errors_count) : be_nil

      expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
      expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
    end
  end

  # POST /api/v1/auth/confirmation(.json) メールアドレス確認API[メール再送](処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   パラメータなし, 有効なパラメータ（メール未確認, メール確認済み, メールアドレス変更中）, 無効なパラメータ, URLがない, URLがホワイトリストにない
  describe 'POST #create' do
    subject { post create_auth_confirmation_path(format: :json), params: attributes, headers: auth_headers }
    let_it_be(:send_user_unconfirmed)   { FactoryBot.create(:user, :unconfirmed) }
    let_it_be(:send_user_confirmed)     { FactoryBot.create(:user) }
    let_it_be(:send_user_email_changed) { FactoryBot.create(:user, :email_changed) }
    let_it_be(:not_user)                { FactoryBot.attributes_for(:user) }
    let(:valid_attributes)       { { email: send_user.email, redirect_url: FRONT_SITE_URL } }
    let(:invalid_attributes)     { { email: not_user[:email], redirect_url: FRONT_SITE_URL } }
    let(:invalid_nil_attributes) { { email: send_user_unconfirmed.email, redirect_url: nil } }
    let(:invalid_bad_attributes) { { email: send_user_unconfirmed.email, redirect_url: BAD_SITE_URL } }
    include_context 'Authテスト内容'
    let(:current_user) { nil }

    # テスト内容
    shared_examples_for 'OK' do
      let(:url)       { "http://#{Settings['base_domain']}#{auth_confirmation_path}" }
      let(:url_param) { "redirect_url=#{URI.encode_www_form_component(attributes[:redirect_url])}" }
      it 'メールが送信される' do
        subject
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(ActionMailer::Base.deliveries[0].subject).to eq(get_subject('devise.mailer.confirmation_instructions.subject')) # メールアドレス確認のお願い
      end
    end

    shared_examples_for 'NG' do
      it 'メールが送信されない' do
        expect { subject }.to change(ActionMailer::Base.deliveries, :count).by(0)
      end
    end

    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。対象項目が一致する。認証ヘッダがない' do
        is_expected.to eq(200)
        expect_success_json
        expect_not_exist_auth_header
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
    shared_examples_for '[*]パラメータなし' do
      let(:attributes) { nil }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 400
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'errors.messages.validate_confirmation_params', nil
    end

    shared_examples_for '[*]有効なパラメータ（メール未確認）' do
      let(:send_user)  { send_user_unconfirmed }
      let(:attributes) { valid_attributes }
      it_behaves_like 'OK'
      it_behaves_like 'ToOK'
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, nil, 'devise_token_auth.confirmations.sended'
    end

    shared_examples_for '[*]有効なパラメータ（メール確認済み）' do
      let(:send_user)  { send_user_confirmed }
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'errors.messages.already_confirmed', nil
    end

    shared_examples_for '[*]有効なパラメータ（メールアドレス変更中）' do
      let(:send_user)  { send_user_email_changed }
      let(:attributes) { valid_attributes }
      it_behaves_like 'OK'
      it_behaves_like 'ToOK'
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, nil, 'devise_token_auth.confirmations.sended'
    end

    shared_examples_for '[*]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', Hash, 2, 'devise_token_auth.confirmations.user_not_found', nil, 'errors.messages.not_saved.one', nil
    end

    shared_examples_for '[*]URLがない' do
      let(:attributes) { invalid_nil_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise_token_auth.confirmations.missing_confirm_success_url', nil
    end

    shared_examples_for '[*]URLがホワイトリストにない' do
      let(:attributes) { invalid_bad_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise_token_auth.confirmations.redirect_url_not_allowed', nil
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[*]パラメータなし'
      it_behaves_like '[*]有効なパラメータ（メール未確認）'
      it_behaves_like '[*]有効なパラメータ（メール確認済み）'
      it_behaves_like '[*]有効なパラメータ（メールアドレス変更中）'
      it_behaves_like '[*]無効なパラメータ'
      it_behaves_like '[*]URLがない'
      it_behaves_like '[*]URLがホワイトリストにない'
    end

    context 'ログイン中' do
      include_context 'ログイン処理'
      it_behaves_like '[*]パラメータなし'
      it_behaves_like '[*]有効なパラメータ（メール未確認）'
      it_behaves_like '[*]有効なパラメータ（メール確認済み）'
      it_behaves_like '[*]有効なパラメータ（メールアドレス変更中）'
      it_behaves_like '[*]無効なパラメータ'
      it_behaves_like '[*]URLがない'
      it_behaves_like '[*]URLがホワイトリストにない'
    end

    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[*]パラメータなし'
      it_behaves_like '[*]有効なパラメータ（メール未確認）'
      it_behaves_like '[*]有効なパラメータ（メール確認済み）'
      it_behaves_like '[*]有効なパラメータ（メールアドレス変更中）'
      it_behaves_like '[*]無効なパラメータ'
      it_behaves_like '[*]URLがない'
      it_behaves_like '[*]URLがホワイトリストにない'
    end
  end
end
