require 'rails_helper'

RSpec.describe Api::V1::Admin::InfomationsController, type: :request do
  describe 'POST /api/v1/admin/infomations' do
    subject(:call_api) { post '/api/v1/admin/infomations/create.json', headers: headers, params: params }

    let(:user) { create(:admin_user) }
    let(:headers) { user.create_new_auth_token }
    let(:params) {{ }}

    context '管理者ユーザーでログインしている場合' do
      context '作成に成功した場合' do
        let(:params) do
          {
            infomation: {
              title: 'infomation_title',
              summary: 'infomation_summary',
              body: 'infomation_body',
              started_at: Time.current,
              ended_at: Time.current + 3.hour,
              target: 'All'
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
          expect { call_api }.to change { Infomation.count }.by(1)
        end
      end

      context '作成に失敗した場合' do
        let(:params) do
          {
            infomation: {
              title: 'infomation_title',
              summary: 'infomation_summary',
              body: 'infomation_body',
              started_at: '',
              ended_at: Time.current + 3.hour,
              target: ''
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
          expect(res['alert']).to eq(I18n.t('alert.infomation.create'))
        end
      end
    end

    context '管理者ユーザー以外のユーザーでログインしている場合' do
      before { user.update(is_admin: false) }

      it 'アクセス権限がないと言われる' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq false
        expect(res['alert']).to eq(I18n.t('errors.messages.not_permission'))
      end
    end
  end

  describe 'POST /api/v1/admin/infomations/:id/delete' do
    subject(:call_api) { post "/api/v1/admin/infomations/#{infomation.id}/delete.json", headers: headers }

    let(:user) { create(:admin_user) }
    let(:headers) { user.create_new_auth_token }
    let(:infomation) { create(:infomation) }

    context '管理者ユーザーでログインしている場合' do
      context '削除に成功した場合' do
        it 'レスポンスステータスが200で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(true)
          expect(response.status).to eq 200
        end

        it '削除されていること' do
          expect { call_api }.to change { Infomation.count }.by(0)
        end

        it 'レスポンスボディーに期待された値が返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['notice']).to eq(I18n.t('notice.infomation.destroy'))
        end
      end
    end

    context '管理者ユーザー以外のユーザーでログインしている場合' do
      before { user.update(is_admin: false) }

      it 'アクセス権限がないと言われる' do
        call_api
        res = JSON.parse(response.body)
        expect(res['success']).to eq false
        expect(res['alert']).to eq(I18n.t('errors.messages.not_permission'))
      end
    end
  end
end
