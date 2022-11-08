require 'rails_helper'

RSpec.describe Api::V1::SheltersController, type: :request do
  describe 'GET /api/v1/shelters' do
    subject(:call_api) { get '/api/v1/shelters.json?prefecture_id=2&id=1100' }

    let!(:shelters) { create_list(:shelter, 5, city_id: 1100) }

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
        expect(res['shelter']['total_count']).to eq(Shelter.all.length)
      end
    end
  end

  describe 'GET /api/v1/shelters/:id' do
    subject(:call_api) { get "/api/v1/shelters/#{shelter.id}.json" }

    let(:shelter) { create(:shelter) }

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
        expect(res['shelter']['id']).to eq(Shelter.last.id)
      end
    end
  end
end
