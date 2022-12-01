require 'rails_helper'

RSpec.describe 'Api::V1::EmergencyContacts', type: :request do
  # POST /api/v1/emergency_contacts/create(.json) 緊急連絡先作成API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   無効なパラメータ, 有効なパラメータ
  describe 'POST #create' do
    subject { post api_v1_create_emergency_contact_path(format: :json), params: attributes, headers: auth_headers }
    let_it_be(:emergency_contact) { FactoryBot.attributes_for(:emergency_contact) }
    let(:valid_attributes) { { emergency_contact: { name: emergency_contact[:name], phone_number: emergency_contact[:phone_number] } } }
    let(:invalid_attributes) { { emergency_contact: { name: nil, phone_number: nil } } }
    let(:current_user) { user }

    # テスト内容
    shared_examples_for 'OK' do
      it '作成される。' do
        expect { subject }.to change(EmergencyContact, :count).by(1) && change(PointRecord, :count).by(1)
      end
    end

    shared_examples_for 'NG' do
      it '作成されない。' do
        expect { subject }.to change(EmergencyContact, :count).by(0) && change(PointRecord, :count).by(0)
      end
    end

    shared_examples_for 'ToMsg' do |code, success, alert, notice|
      it "HTTPステータスが#{code}。対象項目が一致する。" do
        is_expected.to eq(code)
        response_json = response.body.present? ? JSON.parse(response.body) : {}
        expect(response_json['success']).to eq(success)

        expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
        expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
      end
    end

    # テストケース
    shared_examples_for '[未ログイン/ログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 422, false, 'alert.emergency_contact.create', nil
    end

    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'OK'
      it_behaves_like 'ToMsg', 200, true, nil, 'notice.emergency_contact.create'
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
    end

    context 'ログイン中' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
    end

    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[APIログイン中]無効なパラメータ'
      it_behaves_like '[APIログイン中]有効なパラメータ'
    end
  end
end
