require 'rails_helper'

RSpec.describe Api::V1::TaskProfilesController, type: :request do
  describe 'POST /api/v1/task_profiles/update' do
    subject(:call_api) { post "/api/v1/task_profiles/update.json", headers: headers, params: params }

    let(:user) { create(:confirmed_user) }
    let(:headers) { user.create_new_auth_token }
    let(:params) {{ }}

    context 'お気に入りすることに成功した場合' do
      let(:params) do
        {
          sns_task: 1
        }
      end

      it 'レスポンスステータスが200で返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq(true)
        expect(response.status).to eq 200
      end

      it 'お気に入りされていること' do
        expect { call_api }.to change { TaskProfile.count }.by(1)
      end

      it 'レスポンスボディーに期待された値が返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['user']['id']).to eq User.last.id
      end
    end
  end

  describe 'POST /api/v1/task_profiles/delete' do
    subject(:call_api) { post "/api/v1/task_profiles/delete.json", headers: headers, params: params }

    let(:user) { create :confirmed_user }
    let(:headers) { user.create_new_auth_token }
    let(:params) {{ }}
    let!(:task_profile) { create :task_profile, user_id: user.id }
    let!(:point_record) { create :point_record, user_id: user.id, obtained_point: Settings['sns_task_complete_obtained_point'] }

    context 'お気に入りの削除に成功した場合' do
      let(:params) do
        {
          sns_task: 1
        }
      end
      it 'レスポンスステータスが200で返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq(true)
        expect(response.status).to eq 200
      end
    end
  end
end
