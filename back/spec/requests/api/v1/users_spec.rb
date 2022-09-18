require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'GET /api/v1/users' do
    subject(:call_api){ get '/api/v1/users.json' }

    let(:users) { create_list(:user, 5) }

    it 'ユーザー一覧のデータを返す' do
      call_api
      res = JSON.parse(response.body)
      expect(res['success']).to eq(true)
      expect(res['users'].length).to eq(User.all.length)
      expect(response.status).to eq 200
    end
  end

  describe 'GET /api/v1/users/:username' do
    subject(:call_api){ get "/api/v1/users/#{user.username}.json" }

    let(:user) { create(:user) }

    it 'ユーザーのデータを返す' do
      call_api
      res = JSON.parse(response.body)
      expect(res['success']).to eq(true)
      expect(res['user']['id']).to eq(User.last.id)
      expect(res['user']['name']).to eq(User.last.name)
      expect(response.status).to eq 200
    end

    context 'userが存在しない場合' do
      it 'レスポンスステータスが404で返る' do
        get '/api/v1/users/daredesuka.json'
        expect(response.status).to eq 404
      end
    end
  end

  describe 'GET /api/v1/users/:username/genres/:id' do
    subject(:call_api){ get "/api/v1/users/#{user.username}/genres/#{genre.id}.json" }

    let(:user) { create(:user) }
    let(:genre) { create(:genre) }

    it 'ジャンルのデータを返す' do
      call_api
      res = JSON.parse(response.body)
      expect(res['success']).to eq(true)
      expect(res['genre']['id']).to eq(Genre.last.id)
      expect(response.status).to eq 200
    end
  end
end
