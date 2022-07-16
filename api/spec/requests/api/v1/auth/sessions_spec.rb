require 'rails_helper'

RSpec.describe Api::V1::Auth::SessionsController, type: :request do
  describe 'POST /api/v1/auth/sign_in' do
    subject { post(create_auth_session_path(format: :json), params: params) }

    context 'メールアドレス、パスワードが正しく、有効化もされているとき' do
      let(:confirmed_user) { create(:confirmed_user) }
      let(:params) { { email: confirmed_user.email, password: confirmed_user.password } }

      it 'ログインできる' do
        subject
        res = JSON.parse(response.body)
        expect(response.headers['uid']).to be_present
        expect(response.headers['access-token']).to be_present
        expect(response.headers['client']).to be_present
        expect(response).to have_http_status(200)
      end
    end 

    context '有効化はしたが、メールアドレスが正しくないとき' do
      let(:current_user) { create(:confirmed_user) }
      let(:params) { { email: 'test@example.com', password: current_user.password } }

      it 'ログインできない' do
        subject
        res = JSON.parse(response.body)
        expect(res['success']).to be_falsey
        expect(res['alert']).to eq(I18n.t('devise.failure.not_found_in_database'))
        expect(response.headers['uid']).to be_blank
        expect(response.headers['access-token']).to be_blank
        expect(response.headers['client']).to be_blank
        expect(response).to have_http_status(422)
      end
    end

    context '有効化はしたが、パスワードが正しくないとき' do
      let(:current_user) { create(:confirmed_user) }
      let(:params) { { email: current_user.email, password: 'password' } }

      it 'ログインできない' do
        subject
        res = JSON.parse(response.body)
        expect(res['success']).to be_falsey
        expect(res['alert']).to eq(I18n.t('devise.failure.not_found_in_database'))
        expect(response.headers['uid']).to be_blank
        expect(response.headers['access-token']).to be_blank
        expect(response.headers['client']).to be_blank
        expect(response).to have_http_status(422)
      end
    end

    context 'メールアドレス、パスワードは正しいが、有効化されていないとき' do
      let(:current_user) { create(:user) }
      let(:params) { { email: current_user.email, password: current_user.password } }

      it 'ログインできない' do
        subject
        res = JSON.parse(response.body)
        expect(response.headers['uid']).not_to be_present
        expect(response.headers['access-token']).not_to be_present
        expect(response.headers['client']).not_to be_present
        expect(response).to_not have_http_status(200)
      end
    end
  end

  # describe 'POST /api/v1/auth/guest_sign_in' do
  #   context 'メールアドレス、パスワードが正しく、有効化もされているとき' do
  #     it 'ゲストログインできる' do
  #       post(create_guest_auth_session_path(format: :json))
  #       res = JSON.parse(response.body)
  #       p "====="
  #       p res
  #       expect(res['success']).to be_truthy
  #       expect(response.status).to eq 200
  #     end
  #   end
  # end

  describe 'POST /api/v1/auth/sign_out' do

    context 'ユーザーがログインしているとき' do
      let(:user) { create(:confirmed_user) }
      let(:headers) { user.create_new_auth_token }

      it 'ログアウトできる' do
        post(destroy_auth_session_path(format: :json), headers: headers)
        res = JSON.parse(response.body)
        expect(res['success']).to be_truthy
        expect(response.status).to eq 200
      end
    end
  end
end 
