require 'rails_helper'

RSpec.describe Api::V1::HazardMapsController, type: :request do
  describe 'GET /api/v1/hazard_map' do
    subject(:call_api) { get '/api/v1/hazard_map.json?prefecture_id=2&id=1100' }

    let!(:hazard_map) { create(:hazard_map, city_id: 1100) }

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
        expect(res['hazard_map']['id']).to eq(hazard_map.city_id)
      end
    end
  end
end
