require 'rails_helper'

RSpec.describe Api::V1::FamiliesController, type: :request do
  describe 'GET /api/v1/families' do
    subject(:call_api) { get '/api/v1/families.json', headers: headers }

    let(:user) { create(:confirmed_user) }
    let(:headers) { user.create_new_auth_token }
    let(:families) { create_list(:familie, 5, user: user) }

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
        expect(res['families'].length).to eq(Family.all.length)
      end
    end
  end

  describe 'POST /api/v1/families' do
    subject(:call_api) { post '/api/v1/families/create.json', headers: headers, params: params }

    let(:user) { create(:confirmed_user) }
    let(:headers) { user.create_new_auth_token }
    let(:params) {{ }}

    context '緊急時連絡先の作成に成功した場合' do
      let(:params) do
        {
          family: {
            sex: 'Male',
            age: 'Infant',
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

      it '緊急時連絡先が作成されていること' do
        expect { call_api }.to change { Family.count }.by(1)
      end

      it 'レスポンスボディーに期待された値が返ること' do
        call_api
        res = JSON.parse(response.body)
        expect(res['family']['sex']).to eq 'Male'
        expect(res['family']['age']).to eq 'Infant'
        expect(res['user']['id']).to eq user.id
      end
    end

    context '緊急時連絡先の作成に失敗した場合' do
      let(:params) do
        {
          family: {
            sex: '',
            age: '',
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
        expect(res['alert']).to eq(I18n.t('alert.family.create'))
      end
    end
  end

  describe 'POST /api/v1/families/:id/delete' do
    subject(:call_api) { post "/api/v1/families/#{family.id}/delete.json", headers: headers }

    let(:user) { create :confirmed_user }
    let(:user2) { create :confirmed_user, username: 'test_name' }
    let(:headers) { user.create_new_auth_token }
    let(:family) { create :family, user_id: user.id }

    context 'ログインユーザーと緊急時連絡先ユーザーが一致している場合' do
      context '緊急時連絡先の削除に成功した場合' do
        it 'レスポンスステータスが200で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(true)
          expect(response.status).to eq 200
        end

        it '緊急時連絡先が削除されていること' do
          expect { call_api }.to change { Family.count }.by(0)
        end

        it 'レスポンスボディーに期待された値が返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['notice']).to eq(I18n.t('notice.family.destroy'))
        end
      end
    end

    context 'ログインユーザーと緊急時連絡先ユーザーが一致していない場合' do
      before { family.update(user_id: user2.id) }

      it 'アクセス権限がないと言われる' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq false
        expect(res['alert']).to eq(I18n.t('errors.messages.not_permission'))
      end
    end
  end
end
