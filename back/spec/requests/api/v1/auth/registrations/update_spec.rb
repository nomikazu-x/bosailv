require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Registrations', type: :request do
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

  # POST /api/v1/auth/update(.json) ユーザー情報変更API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中, APIログイン中（削除予約済み）
  #   パラメータなし, 有効なパラメータ（変更なし, あり）, 無効なパラメータ, 現在のパスワードがない, URLがない, URLがホワイトリストにない
  describe 'POST #update' do
    subject { post update_auth_registration_path(format: :json), params: attributes, headers: auth_headers }
    let_it_be(:new_user)   { FactoryBot.attributes_for(:user) }
    let_it_be(:exist_user) { FactoryBot.create(:user) }
    let(:nochange_attributes)    { { name: user.name, email: user.email, password: user.password, confirm_redirect_url: FRONT_SITE_URL } }
    let(:valid_attributes)       { { name: new_user[:name], email: new_user[:email], password: new_user[:password], confirm_redirect_url: FRONT_SITE_URL } }
    let(:invalid_attributes)     { { name: exist_user.name, email: exist_user.email, password: exist_user.password, confirm_redirect_url: FRONT_SITE_URL } }
    let(:invalid_nil_attributes) { { name: exist_user.name, email: exist_user.email, password: exist_user.password, confirm_redirect_url: nil } }
    let(:invalid_bad_attributes) { { name: exist_user.name, email: exist_user.email, password: exist_user.password, confirm_redirect_url: BAD_SITE_URL } }
    include_context 'Authテスト内容'
    let(:current_user) { User.find(user.id) }

    # テスト内容
    shared_examples_for 'OK' do |change_email|
      let(:url)       { "http://#{Settings['base_domain']}#{auth_confirmation_path}" }
      let(:url_param) { "redirect_url=#{URI.encode_www_form_component(attributes[:confirm_redirect_url])}" }
      it '対象項目が変更される。対象のメールが送信される' do
        subject
        expect(current_user.unconfirmed_email).to change_email ? eq(attributes[:email]) : eq(user.unconfirmed_email)
        expect(current_user.image.url).to eq(user.image.url)

        expect(ActionMailer::Base.deliveries.count).to eq(change_email ? 3 : 1)
        expect(ActionMailer::Base.deliveries[0].subject).to eq(get_subject('devise.mailer.email_changed.subject')) if change_email # メールアドレス変更受け付けのお知らせ
        expect(ActionMailer::Base.deliveries[change_email ? 1 : 0].subject).to eq(get_subject('devise.mailer.password_change.subject')) # パスワード変更完了のお知らせ
        if change_email
          expect(ActionMailer::Base.deliveries[2].subject).to eq(get_subject('devise.mailer.confirmation_instructions.subject')) # メールアドレス確認のお願い
        end
      end
    end

    shared_examples_for 'NG' do
      it '対象項目が変更されない。メールが送信されない' do
        subject
        expect(current_user.unconfirmed_email).to eq(user.unconfirmed_email)
        expect(current_user.name).to eq(user.name)
        expect(current_user.image.url).to eq(user.image.url)

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
    shared_examples_for '[未ログイン/ログイン中]パラメータなし' do
      let(:attributes) { nil }
      it_behaves_like 'ToNG', 401, nil, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中/削除予約済み]パラメータなし' do
      let(:attributes) { nil }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 400, nil, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'errors.messages.validate_account_update_params', nil
    end

    shared_examples_for '[APIログイン中]有効なパラメータ（変更なし）' do
      let(:attributes) { nochange_attributes.merge(password_confirmation: nochange_attributes[:password], current_password: user.password) }
      it_behaves_like 'OK', false
      it_behaves_like 'ToOK', nil, true, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, nil, 'devise.registrations.updated'
    end

    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ（変更あり）' do
      let(:attributes) { valid_attributes.merge(password_confirmation: valid_attributes[:password]) }
      it_behaves_like 'ToNG', 401, nil, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]有効なパラメータ（変更あり）' do
      let(:attributes) { valid_attributes.merge(password_confirmation: valid_attributes[:password], current_password: user.password) }
      it_behaves_like 'OK', true
      it_behaves_like 'ToOK', nil, true, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, nil, 'devise.registrations.update_needs_confirmation'
    end

    shared_examples_for '[未ログイン/ログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes.merge(password_confirmation: invalid_attributes[:password]) }
      it_behaves_like 'ToNG', 401, nil, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes.merge(password_confirmation: invalid_attributes[:password], current_password: user.password) }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422, nil, false
      it_behaves_like 'ToMsg', Hash, 2, 'activerecord.errors.models.user.attributes.email.taken', nil, 'errors.messages.not_saved.one', nil
    end

    shared_examples_for '[APIログイン中]現在のパスワードがない' do
      let(:attributes) { valid_attributes.merge(password_confirmation: valid_attributes[:password], current_password: nil) }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422, nil, false
      it_behaves_like 'ToMsg', Hash, 2, 'activerecord.errors.models.user.attributes.current_password.blank', nil, 'errors.messages.not_saved.one', nil
    end

    shared_examples_for '[未ログイン/ログイン中]URLがない' do
      let(:attributes) { invalid_nil_attributes.merge(password_confirmation: invalid_nil_attributes[:password]) }
      it_behaves_like 'ToNG', 401, nil, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]URLがない' do
      let(:attributes) { invalid_nil_attributes.merge(password_confirmation: invalid_nil_attributes[:password], current_password: user.password) }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422, nil, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise_token_auth.registrations.confirm_redirect_url_blank', nil
    end

    shared_examples_for '[未ログイン/ログイン中]URLがホワイトリストにない' do
      let(:attributes) { invalid_bad_attributes.merge(password_confirmation: invalid_bad_attributes[:password]) }
      it_behaves_like 'ToNG', 401, nil, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]URLがホワイトリストにない' do
      let(:attributes) { invalid_bad_attributes.merge(password_confirmation: invalid_bad_attributes[:password], current_password: user.password) }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422, nil, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise_token_auth.registrations.confirm_redirect_url_not_allowed', nil
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ（変更あり）'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]URLがない'
      it_behaves_like '[未ログイン/ログイン中]URLがホワイトリストにない'
    end

    context 'ログイン中' do
      include_context 'ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ（変更あり）'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]URLがない'
      it_behaves_like '[未ログイン/ログイン中]URLがホワイトリストにない'
    end

    context 'APIログイン中' do
      include_context 'APIログイン処理', nil
      it_behaves_like '[APIログイン中/削除予約済み]パラメータなし'
      it_behaves_like '[APIログイン中]有効なパラメータ（変更なし）'
      it_behaves_like '[APIログイン中]有効なパラメータ（変更あり）'
      it_behaves_like '[APIログイン中]無効なパラメータ'
      it_behaves_like '[APIログイン中]現在のパスワードがない'
      it_behaves_like '[APIログイン中]URLがない'
      it_behaves_like '[APIログイン中]URLがホワイトリストにない'
    end
  end
end
