require 'rails_helper'

RSpec.describe Api::V1::StocksController, type: :request do
  describe 'GET /api/v1/stocks' do
    subject(:call_api) { get '/api/v1/stocks.json', headers: headers }

    let(:user) { create(:confirmed_user) }
    let(:headers) { user.create_new_auth_token }
    let!(:families) { create_list(:family, 2, user: user) }

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
        expect(res['stocks'][0]['name']).to eq("水（L）")
      end
    end
  end
end
