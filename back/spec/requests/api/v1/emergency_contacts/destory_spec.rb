require 'rails_helper'

RSpec.describe 'Api::V1::EmergencyContacts', type: :request do
  # POST /api/v1/emergency_contacts/:id/delete(.json) 記事削除API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'POST #destroy' do
    subject { post api_v1_delete_emergency_contact_path(id: emergency_contact.id, format: :json), headers: auth_headers }
    let!(:emergency_contact) { FactoryBot.create(:emergency_contact, user: user) }
    let!(:point_record) { FactoryBot.create(:point_record, user: emergency_contact.user, obtained_point: Settings['emergency_contact_create_obtained_point']) }
    let(:current_user) { user }

    # テスト内容
    shared_examples_for 'OK' do
      it '削除される' do
        expect { subject }.to change(EmergencyContact, :count).by(-1) && change(PointRecord, :count).by(-1)
      end
    end
    shared_examples_for 'NG' do
      it '削除されない' do
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
    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    context 'ログイン中' do
      include_context '未ログイン処理'
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like 'OK'
      it_behaves_like 'ToMsg', 200, true, nil, 'notice.emergency_contact.destroy'
    end
  end
end
