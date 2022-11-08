require 'rails_helper'

RSpec.describe Api::V1::ShelterRegistrationsController, type: :request do
  describe 'POST /api/v1/shelters/:id/shelter_registrations/create' do
    subject(:call_api) { post "/api/v1/shelters/#{shelter.id}/shelter_registrations/create.json", headers: headers, params: params }

    let(:user) { create(:confirmed_user) }
    let(:user2) { create(:confirmed_user, username: 'user2') }
    let(:shelter) { create(:shelter)}
    let(:headers) { user2.create_new_auth_token }
    let(:params) {{ }}

    context 'マイ避難所に登録することに成功した場合' do
      let(:params) do
        {
          shelter_registration: {
            user_id: user2.id,
            shelter_id: shelter.id
          }
        }
      end

      it 'レスポンスステータスが200で返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq(true)
        expect(response.status).to eq 200
      end

      it 'マイ避難所に登録されていること' do
        expect { call_api }.to change { ShelterRegistration.count }.by(1)
      end

      it 'レスポンスボディーに期待された値が返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['user']['id']).to eq User.last.id
      end
    end
  end

  describe 'POST /api/v1/shelters/:id/shelter_registrations/delete' do
    subject(:call_api) { post "/api/v1/shelters/#{shelter.id}/shelter_registrations/delete.json", headers: headers }

    let(:user) { create :confirmed_user }
    let(:user2) { create :confirmed_user, username: 'testname' }
    let(:headers) { user.create_new_auth_token }
    let(:shelter) { create :shelter }
    let!(:shelter_registration) { create :shelter_registration, user_id: user.id, shelter_id: shelter.id }
    let!(:point_record) { create :point_record, user_id: user.id, obtained_point: Settings['shelter_registration_obtained_point'] }

    context 'マイ避難所からの削除に成功した場合' do
      it 'レスポンスステータスが200で返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq(true)
        expect(response.status).to eq 200
      end
    end
  end
end
