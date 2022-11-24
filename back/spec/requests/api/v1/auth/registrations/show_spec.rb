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

  # GET /users/auth/detail(.json) ユーザー情報詳細API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'GET #show' do
    subject { get show_auth_registration_path(format: :json), headers: auth_headers }
    include_context 'Authテスト内容'
    let(:current_user) { user }

    # テスト内容
    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。対象項目が一致する。認証ヘッダがある' do
        is_expected.to eq(200)
        response_json = JSON.parse(response.body)
        expect(response_json['success']).to eq(true)
        expect(response_json['user']['code']).to eq(current_user.code)
        expect(response_json['user']['image_url']['mini']).to eq("#{current_user.image_url(:mini)}")
        expect(response_json['user']['image_url']['small']).to eq("#{current_user.image_url(:small)}")
        expect(response_json['user']['image_url']['medium']).to eq("#{current_user.image_url(:medium)}")
        expect(response_json['user']['image_url']['large']).to eq("#{current_user.image_url(:large)}")
        expect(response_json['user']['image_url']['xlarge']).to eq("#{current_user.image_url(:xlarge)}")
        expect(response_json['user']['name']).to eq(current_user.name)
        expect(response_json['user']['email']).to eq(current_user.email)

        expect(response_json['user']['provider']).to eq(current_user.provider)
        expect(response_json['user']['upload_image']).to eq(current_user.image?)
        ## お知らせ
        expect(response_json['user']['infomation_unread_count']).to eq(current_user.infomation_unread_count)

        ## Trackable
        expect(response_json['user']['sign_in_count']).to eq(current_user.sign_in_count)
        current_sign_in_at = current_user.current_sign_in_at.present? ? I18n.l(current_user.current_sign_in_at, format: :json) : nil
        expect(response_json['user']['current_sign_in_at']).to eq(current_sign_in_at)
        last_sign_in_at = current_user.last_sign_in_at.present? ? I18n.l(current_user.last_sign_in_at, format: :json) : nil
        expect(response_json['user']['last_sign_in_at']).to eq(last_sign_in_at)
        expect(response_json['user']['current_sign_in_ip']).to eq(current_user.current_sign_in_ip)
        expect(response_json['user']['last_sign_in_ip']).to eq(current_user.last_sign_in_ip)
        ## Confirmable
        expect(response_json['user']['unconfirmed_email']).to eq(current_user.unconfirmed_email.present? ? current_user.unconfirmed_email : nil)
        ## 作成日時
        expect(response_json['user']['created_at']).to eq(current_user.created_at.present? ? I18n.l(current_user.created_at, format: :json) : nil)

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
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.unauthenticated', nil
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      it_behaves_like 'ToNG', 401
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, 'devise.failure.unauthenticated', nil
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理', :email_changed, true
      it_behaves_like 'ToOK'
      it_behaves_like 'ToMsg', NilClass, 0, nil, nil, nil, nil
    end
  end
end
