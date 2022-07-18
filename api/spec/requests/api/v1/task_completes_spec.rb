require 'rails_helper'

RSpec.describe Api::V1::TaskCompletesController, type: :request do
  describe 'POST /api/v1/tasks/:id/task_completes/create' do
    subject(:call_api) { post "/api/v1/tasks/#{task.id}/task_completes/create.json", headers: headers, params: params }

    let(:user) { create(:confirmed_user) }
    let(:task) { create(:task)}
    let(:headers) { user.create_new_auth_token }
    let(:params) {{ }}

    context 'お気に入りすることに成功した場合' do
      let(:params) do
        {
          task_complete: {
            user_id: user.id,
            task_id: task.id
          }
        }
      end

      it 'レスポンスステータスが200で返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq(true)
        expect(response.status).to eq 200
      end

      it 'お気に入りされていること' do
        expect { call_api }.to change { TaskComplete.count }.by(1)
      end

      it 'レスポンスボディーに期待された値が返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['user']['id']).to eq User.last.id
      end
    end
  end

  describe 'POST /api/v1/tasks/:id/task_completes/delete' do
    subject(:call_api) { post "/api/v1/tasks/#{task.id}/task_completes/delete.json", headers: headers }

    let(:user) { create :confirmed_user }
    let(:headers) { user.create_new_auth_token }
    let(:task) { create :task }
    let!(:task_complete) { create :task_complete, user_id: user.id, task_id: task.id }
    let!(:point_record) { create :point_record, user_id: user.id, obtained_point: Settings['task_complete_obtained_point'] }

    context 'お気に入りの削除に成功した場合' do
      it 'レスポンスステータスが200で返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq(true)
        expect(response.status).to eq 200
      end
    end
  end
end
