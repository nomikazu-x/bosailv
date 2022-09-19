require 'rails_helper'

RSpec.describe Api::V1::ArticlesController, type: :request do
  describe 'GET /api/v1/articles' do
    subject(:call_api) { get '/api/v1/articles.json' }

    let(:article) { create_list(:article, 5) }

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
        expect(res['articles'].length).to eq(Article.all.length)
      end
    end
  end

  describe 'POST /api/v1/articles' do
    subject(:call_api) { post '/api/v1/articles/create.json', headers: headers, params: params }

    let(:user) { create(:confirmed_user) }
    let(:headers) { user.create_new_auth_token }
    let(:params) {{ }}

    context '投稿の作成に成功した場合' do
      let(:params) do
        {
          article: {
            title: 'article_title',
            content: 'article_content',
            user_id: user.id
          }
        }
      end

      it 'レスポンスステータスが200で返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq(true)
        expect(response.status).to eq 200
      end

      it '投稿が作成されていること' do
        expect { call_api }.to change { Article.count }.by(1)
      end

      it 'レスポンスボディーに期待された値が返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['article']['title']).to eq 'article_title'
        expect(res['article']['content']).to eq 'article_content'
        expect(res['article']['user']['id']).to eq user.id
      end
    end

    context '投稿の作成に失敗した場合' do
      let(:params) do
        {
          article: {
            title: '',
            content: 'article_content',
            user_id: user.id
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
        expect(res['alert']).to eq(I18n.t('alert.article.create'))
      end
    end
  end

  describe 'POST /api/v1/articles/:id/update' do
    subject(:call_api) { post "/api/v1/articles/#{article.id}/update.json", headers: headers, params: params }

    let(:user) { create :confirmed_user }
    let(:user2) { create :confirmed_user, username: 'test_name' }
    let(:headers) { user.create_new_auth_token }
    let(:article) { create :article, user_id: user.id }
    let(:params) {{ }}

    context 'ログインユーザーと投稿ユーザーが一致している場合' do
      context '投稿の更新に成功した場合' do
        let(:params) do
          {
            article: {
              title: 'update_article_title',
              content: 'update_article_content',
              user_id: user.id
            }
          }
        end

        it 'レスポンスステータスが200で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(true)
          expect(response.status).to eq 200
        end

        it 'レスポンスボディーに期待された値が返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['article']['title']).to eq 'update_article_title'
          expect(res['article']['content']).to eq 'update_article_content'
          expect(res['article']['user']['id']).to eq user.id
        end
      end

      context '投稿の更新に失敗した場合' do
        let(:params) do
          {
            article: {
              title: '',
              content: 'update_article_content',
              user_id: user.id
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
          expect(res['alert']).to eq(I18n.t('alert.article.update'))
        end
      end
    end

    context 'ログインユーザーと投稿ユーザーが一致していない場合' do
      before { article.update(user_id: user2.id) }

      it 'アクセス権限がないと言われる' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq false
        expect(res['alert']).to eq(I18n.t('errors.messages.not_permission'))
      end
    end
  end

  describe 'POST /api/v1/articles/:id/delete' do
    subject(:call_api) { post "/api/v1/articles/#{article.id}/delete.json", headers: headers }

    let(:user) { create :confirmed_user }
    let(:user2) { create :confirmed_user, username: 'test_name' }
    let(:headers) { user.create_new_auth_token }
    let(:article) { create :article, user_id: user.id }
    let!(:point_record) { create :point_record, user_id: user.id }

    context 'ログインユーザーと投稿ユーザーが一致している場合' do
      context '投稿の削除に成功した場合' do
        it 'レスポンスステータスが200で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(true)
          expect(response.status).to eq 200
        end

        it '投稿が削除されていること' do
          expect { call_api }.to change { Article.count }.by(0)
        end

        it 'レスポンスボディーに期待された値が返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['notice']).to eq(I18n.t('notice.article.destroy'))
        end
      end
    end

    context 'ログインユーザーと投稿ユーザーが一致していない場合' do
      before { article.update(user_id: user2.id) }

      it 'アクセス権限がないと言われる' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq false
        expect(res['alert']).to eq(I18n.t('errors.messages.not_permission'))
      end
    end
  end

  describe 'GET /api/v1/articles/search' do
    subject(:call_api) { get '/api/v1/articles/search.json' }

    let(:article) { create_list(:article, 5) }
    let(:article) { create(:article, title: 'test') }

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
        expect(res['articles'].length).to eq(Article.all.length)
      end
    end
    it '検索条件に合致したレスポンスを返却すること' do
      keyword = URI.encode_www_form(keyword: 'test')
      get "/api/v1/articles/search.json?#{keyword}&per=#{Settings['default_articles_limit']}&page=1"

      res = JSON.parse(response.body)
      expect(res['success']).to eq(true)
    end
  end
end
