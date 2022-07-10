require 'rails_helper'

RSpec.describe Api::V1::CitiesController, type: :request do
  describe 'GET /api/v1/set_cities' do
    context 'リクエストに成功した場合' do
      it 'レスポンスステータスが200で返ること' do
        get '/api/v1/set_cities.json', params: { id: Prefecture.first.id }
        expect(response.status).to eq 200
      end

      it 'レスポンスボディーに期待された値が返ること' do
        get '/api/v1/set_cities.json', params: { id: Prefecture.first.id }
        res = JSON.parse(response.body)
        expect(res.first['id']).to eq Prefecture.first.cities.first.id
      end
    end
  end
end
