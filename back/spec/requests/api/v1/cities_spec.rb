require 'rails_helper'

RSpec.describe Api::V1::CitiesController, type: :request do
  describe 'GET /api/v1/set_cities/_id' do
    context 'リクエストに成功した場合' do
      it 'レスポンスステータスが200で返ること' do
        get "/api/v1/set_cities/#{Prefecture.first.id}.json"
        expect(response.status).to eq 200
      end

      it 'レスポンスボディーに期待された値が返ること' do
        get "/api/v1/set_cities/#{Prefecture.first.id}.json"
        res = JSON.parse(response.body)
        expect(res.first['name']).to eq Prefecture.first.cities.first.name
      end
    end
  end
end
