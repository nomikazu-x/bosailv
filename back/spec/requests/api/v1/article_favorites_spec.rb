require 'rails_helper'

RSpec.describe Api::V1::ArticleFavoritesController, type: :request do
  describe 'POST /api/v1/articles/:id/article_favorites/create' do
    subject(:call_api) { post "/api/v1/articles/#{article.id}/article_favorites/create.json", headers: headers, params: params }

    let(:user) { create(:confirmed_user) }
    let(:user2) { create(:confirmed_user, username: 'user2') }
    let(:article) { create(:article, user: user)}
    let(:headers) { user2.create_new_auth_token }
    let(:params) {{ }}

    context 'お気に入りすることに成功した場合' do
      let(:params) do
        {
          article_favorite: {
            user_id: user2.id,
            article_id: article.id
          }
        }
      end

      it 'レスポンスステータスが200で返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq(true)
        expect(response.status).to eq 200
      end

      it 'お気に入りされていること' do
        expect { call_api }.to change { ArticleFavorite.count }.by(1)
      end

      it 'レスポンスボディーに期待された値が返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['user']['id']).to eq User.last.id
      end
    end
  end

  describe 'POST /api/v1/articles/:id/article_favorites/delete' do
    subject(:call_api) { post "/api/v1/articles/#{article.id}/article_favorites/delete.json", headers: headers }

    let(:user) { create :confirmed_user }
    let(:user2) { create :confirmed_user, username: 'testname' }
    let(:headers) { user.create_new_auth_token }
    let(:article) { create :article, user_id: user2.id }
    let!(:article_favorite) { create :article_favorite, user_id: user.id, article_id: article.id }
    let!(:point_record) { create :point_record, user_id: user.id, obtained_point: Settings['article_favorite_reader_obtained_point'] }
    let!(:point_record2) { create :point_record, user_id: user2.id, obtained_point: Settings['article_favorite_author_obtained_point'] }

    context 'お気に入りの削除に成功した場合' do
      it 'レスポンスステータスが200で返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq(true)
        expect(response.status).to eq 200
      end
    end
  end
end
