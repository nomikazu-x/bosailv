require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe "GET /api/v1/users/:username" do
    subject(:call_api){ get "/api/v1/users/#{user.username}.json" }

    let(:user) { create(:user) }

    it "ユーザーのデータを返す" do
      call_api
      res = JSON.parse(response.body)
      expect(res["user"]["id"]).to eq(User.last.id)
      expect(res["user"]["name"]).to eq(User.last.name)
      expect(response.status).to eq 200
    end

    context "userが存在しない場合" do
      it 'レスポンスステータスが404で返る' do
        get "/api/v1/users/daredesuka.json"
        expect(response.status).to eq 404
      end
    end
  end
end
