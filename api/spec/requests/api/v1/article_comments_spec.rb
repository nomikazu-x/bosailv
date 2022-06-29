require 'rails_helper'

RSpec.describe Api::V1::ArticleCommentsController, type: :request do
  describe 'POST /api/v1/article_comments/create' do
    subject(:call_api) { post '/api/v1/article_comments/create.json', headers: headers, params: params }

    let(:user) { create(:confirmed_user) }
    let(:article) { create(:article, user: user)}
    let(:headers) { user.create_new_auth_token }
    let(:params) {{ }}

    context '投稿の作成に成功した場合' do
      let(:params) do
        {
          article_comment: {
            content: 'article_comment',
            user_id: user.id,
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

      it '投稿が作成されていること' do
        expect { call_api }.to change { ArticleComment.count }.by(1)
      end

      it 'レスポンスボディーに期待された値が返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['comment']['id']).to eq ArticleComment.last.id
        expect(res['comment']['content']).to eq 'article_comment'
        expect(res['comment']['user']['id']).to eq user.id
      end
    end

    context '投稿の作成に失敗した場合' do
      let(:params) do
        {
          article_comment: {
            content: '',
            user_id: user.id,
            article_id: article.id
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
        expect(res['alert']).to eq(I18n.t('alert.article_comment.create'))
      end
    end
  end

  describe 'POST /api/v1/article_comments/:id/delete' do
    subject(:call_api) { post "/api/v1/article_comments/#{article_comment.id}/delete.json", headers: headers }

    let(:user) { create :confirmed_user }
    let(:headers) { user.create_new_auth_token }
    let(:article) { create :article, user_id: user.id }
    let(:article_comment) { create :article_comment, user_id: user.id, article_id: article.id }

    context 'ログインユーザーと投稿ユーザーが一致している場合' do
      context '投稿の削除に成功した場合' do
        it 'レスポンスステータスが200で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(true)
          expect(response.status).to eq 200
        end

        it '投稿が削除されていること' do
          expect { call_api }.to change { ArticleComment.count }.by(0)
        end

        it 'レスポンスボディーに期待された値が返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['notice']).to eq(I18n.t('notice.article_comment.destroy'))
        end
      end
    end
  end
end
