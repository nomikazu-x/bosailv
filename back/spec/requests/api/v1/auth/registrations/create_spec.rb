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

  # POST /api/v1/auth/sign_up(.json) アカウント登録API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   パラメータなし, 有効なパラメータ, 無効なパラメータ, URLがない, URLがホワイトリストにない
  describe 'POST #create' do
    subject { post create_auth_registration_path(format: :json), params: attributes, headers: auth_headers }
    let_it_be(:new_user)   { FactoryBot.attributes_for(:user) }
    let_it_be(:exist_user) { FactoryBot.create(:user) }
    let(:valid_attributes)       { { name: new_user[:name], email: new_user[:email], password: new_user[:password], confirm_success_url: FRONT_SITE_URL } }
    let(:invalid_attributes)     { { name: exist_user.name, email: exist_user.email, password: exist_user.password, confirm_success_url: FRONT_SITE_URL } }
    let(:invalid_nil_attributes) { { name: new_user[:name], email: new_user[:email], password: new_user[:password], confirm_success_url: nil } }
    let(:invalid_bad_attributes) { { name: new_user[:name], email: new_user[:email], password: new_user[:password], confirm_success_url: BAD_SITE_URL } }
    include_context 'Authテスト内容'
    let(:current_user) { User.find_by!(email: attributes[:email]) }

    # テスト内容
    shared_examples_for 'OK' do
      let(:url)       { "http://#{Settings['base_domain']}#{auth_confirmation_path}" }
      let(:url_param) { "redirect_url=#{URI.encode_www_form_component(attributes[:confirm_success_url])}" }
      it '作成・対象項目が設定される。メールが送信される' do
        expect do
          subject
          expect(current_user.name).to eq(attributes[:name]) # メールアドレス、氏名

          expect(ActionMailer::Base.deliveries.count).to eq(1)
          expect(ActionMailer::Base.deliveries[0].subject).to eq(get_subject('devise.mailer.confirmation_instructions.subject')) # メールアドレス確認のお願い
        end.to change(User, :count).by(1)
      end
    end

    shared_examples_for 'NG' do
      it '作成されない。メールが送信されない' do
        expect { subject }.to change(User, :count).by(0) && change(ActionMailer::Base.deliveries, :count).by(0)
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
    shared_examples_for '[未ログイン/ログイン中]パラメータなし' do
      let(:attributes) { nil }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 400, nil, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'errors.messages.validate_sign_up_params', nil
    end

    shared_examples_for '[APIログイン中]パラメータなし' do
      let(:attributes) { nil }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 401, nil, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'OK'
      it_behaves_like 'ToOK', nil, true, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, nil, 'devise.registrations.signed_up_but_unconfirmed'
    end
    shared_examples_for '[APIログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 401, nil, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end
    shared_examples_for '[未ログイン/ログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422, nil, false, false
      it_behaves_like 'ToMsg', Hash, 2, 'activerecord.errors.models.user.attributes.email.taken', nil, 'errors.messages.not_saved.one', nil
    end

    shared_examples_for '[APIログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 401, nil, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    shared_examples_for '[未ログイン/ログイン中]URLがない' do
      let(:attributes) { invalid_nil_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422, nil, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise_token_auth.registrations.missing_confirm_success_url', nil
    end

    shared_examples_for '[APIログイン中]URLがない' do
      let(:attributes) { invalid_nil_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 401, nil, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    shared_examples_for '[未ログイン/ログイン中]URLがホワイトリストにない' do
      let(:attributes) { invalid_bad_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422, nil, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise_token_auth.registrations.redirect_url_not_allowed', nil
    end

    shared_examples_for '[APIログイン中]URLがホワイトリストにない' do
      let(:attributes) { invalid_bad_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 401, nil, false, false
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.already_authenticated', nil
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]URLがない'
      it_behaves_like '[未ログイン/ログイン中]URLがホワイトリストにない'
    end

    context 'ログイン中' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]パラメータなし'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]URLがない'
      it_behaves_like '[未ログイン/ログイン中]URLがホワイトリストにない'
    end

    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[APIログイン中]パラメータなし'
      it_behaves_like '[APIログイン中]有効なパラメータ'
      it_behaves_like '[APIログイン中]無効なパラメータ'
      it_behaves_like '[APIログイン中]URLがない'
      it_behaves_like '[APIログイン中]URLがホワイトリストにない'
    end
  end
end
