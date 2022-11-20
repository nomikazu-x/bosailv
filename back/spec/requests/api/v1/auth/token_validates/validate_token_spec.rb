require 'rails_helper'

RSpec.describe 'Api::V1::Auth::TokenValidations', type: :request do
  # テスト内容（共通）
  shared_examples_for 'ToMsg' do |error_msg, alert, notice|
    it '対象のメッセージと一致する' do
      subject
      response_json = JSON.parse(response.body)
      expect(response_json['errors'].to_s).to error_msg.present? ? include(I18n.t(error_msg)) : be_blank

      expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
      expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
    end
  end

  # GET /api/v1/auth/validate_token(.json) トークン検証API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'GET #validate_token' do
    subject { get auth_validate_token_path(format: :json), headers: auth_headers }
    include_context 'Authテスト内容'
    let(:current_user) { user }

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

    # テストケース
    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like 'ToNG', 401
      it_behaves_like 'ToMsg', nil, 'devise_token_auth.token_validations.invalid', nil
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      it_behaves_like 'ToNG', 401
      it_behaves_like 'ToMsg', nil, 'devise_token_auth.token_validations.invalid', nil
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like 'ToOK', false
      it_behaves_like 'ToMsg', nil, nil, nil
    end
  end
end