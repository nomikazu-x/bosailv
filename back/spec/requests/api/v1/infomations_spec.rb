require 'rails_helper'

RSpec.describe Api::V1::InfomationsController, type: :request do
  describe 'GET /api/v1/infomations' do
    subject(:call_api) { get '/api/v1/infomations.json', headers: headers }

    let(:user) { create(:admin_user) }
    let(:headers) { user.create_new_auth_token }
    let!(:infomation) { create_list(:infomation, 5) }

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
        expect(res['infomations'].length).to eq(Infomation.all.length)
      end
    end
  end

  describe 'GET /api/v1/infomations/important' do
    subject(:call_api) { get '/api/v1/infomations/important.json' }

    let!(:infomation) { create_list(:infomation, 5, force_started_at: Time.current, force_ended_at: Time.current + 2.hour) }

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
        expect(res['infomations'].length).to eq(Infomation.all.length)
      end
    end
  end

  describe 'GET /api/v1/infomations/:id' do
    subject(:call_api) { get "/api/v1/infomations/#{infomation.id}.json" }

    let(:infomation) { create(:infomation) }

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
        expect(res['infomation']['label']).to eq(Infomation.last.label)
        expect(res['infomation']['title']).to eq(Infomation.last.title)
        expect(res['infomation']['target']).to eq(Infomation.last.target)
      end
    end
  end
end
