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

  # POST /api/v1/auth/image/update(.json) ユーザー画像変更API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中, APIログイン中（削除予約済み）
  #   有効なパラメータ, 無効なパラメータ
  describe 'POST #image_update' do
    subject { post update_auth_image_registration_path(format: :json), params: attributes, headers: auth_headers }
    let(:valid_attributes)   { { image: fixture_file_upload(TEST_IMAGE_FILE, TEST_IMAGE_TYPE) } }
    let(:invalid_attributes) { nil }
    include_context 'Authテスト内容'
    let(:current_user) { User.find(user.id) }

    # テスト内容
    shared_examples_for 'OK' do
      it '画像が変更される' do
        subject
        expect(current_user.image.url).not_to eq(user.image.url)
      end
    end
    shared_examples_for 'NG' do
      it '画像が変更されない' do
        subject
        expect(current_user.image.url).to eq(user.image.url)
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
    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToNG', 401
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.unauthenticated', nil
    end
    shared_examples_for '[APIログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'OK'
      it_behaves_like 'ToOK'
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, nil, 'notice.user.image_update'
    end
    shared_examples_for '[未ログイン/ログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'ToNG', 401
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.unauthenticated', nil
    end
    shared_examples_for '[APIログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 422
      it_behaves_like 'ToMsg', Hash, 2, 'errors.messages.image_update_blank', nil, 'errors.messages.not_saved.one', nil
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[APIログイン中]有効なパラメータ'
      it_behaves_like '[APIログイン中]無効なパラメータ'
    end
  end
end
