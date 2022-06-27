require 'rails_helper'

RSpec.describe Api::V1::Auth::RegistrationsController, type: :request do
  describe 'POST /api/v1/auth/sign_up' do
    subject { post(create_auth_registration_path(format: :json), params: params) }

    let(:params) { attributes_for(:user) }

    it 'ユーザー登録できる' do
      subject
      res = JSON.parse(response.body)
      expect(res['user']['id']).to eq(User.last.id)
      expect(res['user']['username']).to eq(User.last.username)
      expect(response.status).to eq 200
    end
  end

  describe 'POST /api/v1/auth/delete' do

    let(:user) { create(:confirmed_user) }
    let(:headers) { user.create_new_auth_token }

    it 'ユーザー削除できる' do
      post destroy_auth_registration_path(format: :json), headers: headers
      res = JSON.parse(response.body)
      expect(res['success']).to be_truthy
      expect(User.all.size).to eq 0
    end
  end

  describe 'POST /api/v1/auth/update' do

    context '渡す値が正しいとき' do
      let(:user) { create(:confirmed_user) }
      let(:headers) { user.create_new_auth_token }
      let(:params) { { name: 'テスト太郎', profile: 'テストマンだよ' } }

      it '値を変更できる' do
        post update_auth_registration_path(format: :json), params: params, headers: headers
        res = JSON.parse(response.body)
        expect(res['user']['name']).to eq('テスト太郎')
        expect(res['user']['profile']).to eq('テストマンだよ')
      end
    end

    context '渡す値が正しくないとき' do
      let(:user) { create(:confirmed_user) }
      let(:params) { { id: '3' } }

      it '値を変更できない' do
        post update_auth_registration_path(format: :json), params: params, headers: headers
        res = JSON.parse(response.body)
        expect(res['success']).to be_falsey
        expect(res['alert']).to eq(I18n.t('devise_token_auth.sessions.bad_credentials'))
      end
    end
  end
end 
