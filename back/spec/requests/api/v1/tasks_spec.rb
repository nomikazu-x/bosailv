require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :request do
  describe 'GET /api/v1/tasks' do
    subject(:call_api) { get '/api/v1/tasks.json' }

    let(:task) { create_list(:task, 5) }

    context 'リクエストに成功した場合' do
      it 'レスポンスステータスが200で返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq(true)
        expect(response.status).to eq 200
      end

      it 'レスポンスボディーに期待された値が返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['tasks'].length).to eq(Task.all.length)
      end
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    subject(:call_api) { get "/api/v1/tasks/#{task.id}.json" }

    let(:task) { create(:task) }

    context 'リクエストに成功した場合' do
      it 'レスポンスステータスが200で返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq(true)
        expect(response.status).to eq 200
      end

      it 'レスポンスボディーに期待された値が返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['task']['id']).to eq(Task.last.id)
      end
    end
  end
end
