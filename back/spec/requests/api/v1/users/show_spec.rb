require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  # GET /api/v1/users/:username(.json) タスク詳細API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'GET #show' do
    subject { get api_v1_user_path(username: other_user.username, format: :json), headers: auth_headers }

    shared_context 'タスク作成' do
      let_it_be(:other_user) { FactoryBot.create(:user) }
    end

    # テスト内容
    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)['user']
        expect(response_json['id']).to eq(other_user.id)
        expect(response_json['code']).to eq(other_user.code)
        expect(response_json['username']).to eq(other_user.username)
        expect(response_json['image_url']['mini']).to eq("#{other_user.image_url(:mini)}")
        expect(response_json['image_url']['small']).to eq("#{other_user.image_url(:small)}")
        expect(response_json['image_url']['medium']).to eq("#{other_user.image_url(:medium)}")
        expect(response_json['image_url']['large']).to eq("#{other_user.image_url(:large)}")
        expect(response_json['image_url']['xlarge']).to eq("#{other_user.image_url(:xlarge)}")
        expect(response_json['name']).to eq(other_user.name)
        # expect(response_json['email']).to eq(other_user.email)
        expect(response_json['profile']).to eq(other_user.profile)
        expect(response_json['level']).to eq(other_user.level)
        expect(response_json['lifelong_point']).to eq(other_user.lifelong_point)
      end
    end
    shared_examples_for 'ToNot' do |success, alert, notice|
      it "HTTPステータスが401。対象項目が一致する" do
        is_expected.to eq(code)
        response_json = response.body.present? ? JSON.parse(response.body) : {}
        expect(response_json['success']).to eq(success)

        expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
        expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
      end
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      include_context 'タスク作成'
      it_behaves_like 'ToOK'
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      include_context 'タスク作成'
      it_behaves_like 'ToOK'
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      include_context 'タスク作成'
      it_behaves_like 'ToOK'
    end
  end
end
