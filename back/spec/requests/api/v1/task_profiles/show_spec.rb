require 'rails_helper'

RSpec.describe 'Api::V1::TaskProfiles', type: :request do
  # GET /api/v1/task_profile(.json) タスクプロフィール詳細API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'GET #show' do
    subject { get api_v1_task_profile_path(format: :json), headers: auth_headers }

    shared_context 'タスクプロフィール作成' do
      let_it_be(:task_profile) { FactoryBot.create(:task_profile, user_id: user.id) }
    end

    # テスト内容
    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)

        expect(response_json['sns_tasks'].count).to eq(TaskProfile.sns_tasks.pairs.count)
        (0..TaskProfile.sns_tasks.pairs.count - 1).each do |no|
          data = response_json['sns_tasks'][no]
          sns_task = TaskProfile.sns_tasks.pairs.to_a[no]
          expect(data['name']).to eq(sns_task[0])
          expect(data['value']).to eq(sns_task[1].to_s)
          expect(data['is_completed']).to eq(task_profile.sns_tasks.set?(sns_task[1]))
        end

        (0..TaskProfile.house_tasks.pairs.count - 1).each do |no|
          data = response_json['house_tasks'][no]
          house_task = TaskProfile.house_tasks.pairs.to_a[no]
          expect(data['name']).to eq(house_task[0])
          expect(data['value']).to eq(house_task[1].to_s)
          expect(data['is_completed']).to eq(task_profile.sns_tasks.set?(house_task[1]))
        end
      end
    end
    shared_examples_for 'ToNot' do |success, alert, notice|
      it 'HTTPステータスが401。対象項目が一致する' do
        is_expected.to eq(401)
        response_json = response.body.present? ? JSON.parse(response.body) : {}
        expect(response_json['success']).to eq(success)

        expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
        expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
      end
    end

    # テストケース
    context '未ログイン' do
      include_context '未ログイン処理'
      include_context 'タスクプロフィール作成'
      it_behaves_like 'ToNot', false, 'devise.failure.unauthenticated', nil
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      include_context 'タスクプロフィール作成'
      it_behaves_like 'ToNot', false, 'devise.failure.unauthenticated', nil
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      include_context 'タスクプロフィール作成'
      it_behaves_like 'ToOK'
    end
  end
end
