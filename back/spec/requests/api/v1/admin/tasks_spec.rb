require 'rails_helper'

RSpec.describe Api::V1::Admin::TasksController, type: :request do
  describe 'POST /api/v1/admin/tasks' do
    subject(:call_api) { post '/api/v1/admin/tasks/create.json', headers: headers, params: params }

    let(:user) { create(:admin_user) }
    let(:headers) { user.create_new_auth_token }
    let(:image) { Rack::Test::UploadedFile.new('spec/fixtures/test_image.jpg', 'image/jpeg') }
    let(:params) {{ }}

    context '管理者ユーザーでログインしている場合' do
      context '作成に成功した場合' do
        let(:params) do
          {
            task: {
              title: 'task_title',
              image: image,
              summary: 'task_summary',
              body: 'task_body',
              icon: 'task_icon'
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
          expect { call_api }.to change { Task.count }.by(1)
        end
      end

      context '作成に失敗した場合' do
        let(:params) do
          {
            task: {
              title: 'task_title',
              image: image,
              summary: 'task_summary',
              body: '',
              icon: ''
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
          expect(res['alert']).to eq(I18n.t('alert.task.create'))
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

  describe 'POST /api/v1/admin/tasks/:id/update' do
    subject(:call_api) { post "/api/v1/admin/tasks/#{task.id}/update.json", headers: headers, params: params }

    let(:user) { create(:admin_user) }
    let(:headers) { user.create_new_auth_token }
    let(:task) { create(:task) }
    let(:image) { Rack::Test::UploadedFile.new('spec/fixtures/test_image.jpg', 'image/jpeg') }
    let(:params) {{ }}

    context '管理者ユーザーでログインしている場合' do
      context '投稿の更新に成功した場合' do
        let(:params) do
          {
            task: {
              title: 'task_title',
              image: image,
              summary: 'task_summary',
              body: 'task_body',
              icon: 'task_icon'
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
            task: {
              title: 'task_title',
              image: image,
              summary: 'task_summary',
              body: '',
              icon: ''
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
          expect(res['alert']).to eq(I18n.t('alert.task.update'))
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

  describe 'POST /api/v1/admin/tasks/:id/delete' do
    subject(:call_api) { post "/api/v1/admin/tasks/#{task.id}/delete.json", headers: headers }

    let(:user) { create(:admin_user) }
    let(:headers) { user.create_new_auth_token }
    let(:task) { create(:task) }

    context '管理者ユーザーでログインしている場合' do
      context '削除に成功した場合' do
        it 'レスポンスステータスが200で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(true)
          expect(response.status).to eq 200
        end

        it '削除されていること' do
          expect { call_api }.to change { Task.count }.by(0)
        end

        it 'レスポンスボディーに期待された値が返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['notice']).to eq(I18n.t('notice.task.destroy'))
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
