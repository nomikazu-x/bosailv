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

  describe 'POST /api/v1/genres' do
    subject(:call_api) { post '/api/v1/genres/create.json', headers: headers, params: params }

    let(:user) { create(:admin_user) }
    let(:headers) { user.create_new_auth_token }
    let(:image) { Rack::Test::UploadedFile.new('spec/fixtures/test_image.jpg', 'image/jpeg') }
    let(:params) {{ }}

    context '管理者ユーザーでログインしている場合' do
      context '作成に成功した場合' do
        let(:params) do
          {
            genre: {
              name: 'genre_name',
              image: image
            }
          }
        end
        it 'レスポンスステータスが200で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(true)
          expect(response.status).to eq 200
        end

        it '作成されていること' do
          expect { call_api }.to change { Genre.count }.by(1)
        end
      end

      context '作成に失敗した場合' do
        let(:params) do
          {
            genre: {
              name: '',
              image: ''
            }
          }
        end

        it 'レスポンスステータスが422で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(false)
          expect(response.status).to eq 422
        end

        it 'エラーが返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(false)
          expect(res['alert']).to eq(I18n.t('alert.genre.create'))
        end
      end
    end

    context '管理者ユーザー以外のユーザーでログインしている場合' do
      before { user.update(admin: false) }

      it 'アクセス権限がないと言われる' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq false
        expect(res['alert']).to eq(I18n.t('errors.messages.not_permission'))
      end
    end
  end

  describe 'POST /api/v1/genres/:id/update' do
    subject(:call_api) { post "/api/v1/genres/#{genre.id}/update.json", headers: headers, params: params }

    let(:user) { create(:admin_user) }
    let(:headers) { user.create_new_auth_token }
    let(:genre) { create :genre }
    let(:image) { Rack::Test::UploadedFile.new('spec/fixtures/test_image.jpg', 'image/jpeg') }
    let(:params) {{ }}

    context '管理者ユーザーでログインしている場合' do
      context '投稿の更新に成功した場合' do
        let(:params) do
          {
            genre: {
              name: 'genre_name',
              image: image
            }
          }
        end

        it 'レスポンスステータスが200で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(true)
          expect(response.status).to eq 200
        end
      end

      context '投稿の更新に失敗した場合' do
        let(:params) do
          {
            genre: {
              name: '',
              image: image
            }
          }
        end

        it 'レスポンスステータスが422で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(false)
          expect(response.status).to eq 422
        end

        it 'エラーが返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(false)
          expect(res['alert']).to eq(I18n.t('alert.genre.update'))
        end
      end
    end

    context '管理者ユーザー以外のユーザーでログインしている場合' do
      before { user.update(admin: false) }

      it 'アクセス権限がないと言われる' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq false
        expect(res['alert']).to eq(I18n.t('errors.messages.not_permission'))
      end
    end
  end

  describe 'POST /api/v1/genres/:id/delete' do
    subject(:call_api) { post "/api/v1/genres/#{genre.id}/delete.json", headers: headers }

    let(:user) { create(:admin_user) }
    let(:headers) { user.create_new_auth_token }
    let(:genre) { create(:genre) }

    context '管理者ユーザーでログインしている場合' do
      context '削除に成功した場合' do
        it 'レスポンスステータスが200で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(true)
          expect(response.status).to eq 200
        end

        it '削除されていること' do
          expect { call_api }.to change { Genre.count }.by(0)
        end

        it 'レスポンスボディーに期待された値が返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['notice']).to eq(I18n.t('notice.genre.destroy'))
        end
      end
    end

    context '管理者ユーザー以外のユーザーでログインしている場合' do
      before { user.update(admin: false) }

      it 'アクセス権限がないと言われる' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq false
        expect(res['alert']).to eq(I18n.t('errors.messages.not_permission'))
      end
    end
  end
end
