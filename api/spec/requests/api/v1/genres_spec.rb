require 'rails_helper'

RSpec.describe Api::V1::GenresController, type: :request do
  describe 'GET /api/v1/genres' do
    subject(:call_api) { get '/api/v1/genres.json' }

    let(:genre) { create_list(:genre, 5) }

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
        expect(res['genres'].length).to eq(Genre.all.length)
      end
    end
  end

  describe 'GET /api/v1/genres/:id' do
    subject(:call_api) { get "/api/v1/genres/#{genre.id}.json" }

    let(:genre) { create(:genre) }
    let(:article) { create(:article) }
    let!(:article_genre_relation) { create(:article_genre_relation, article_id: article.id, genre_id: genre.id) }

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
        expect(res['articles'].length).to eq(Genre.last.articles.all.length)
      end
    end
  end
end
