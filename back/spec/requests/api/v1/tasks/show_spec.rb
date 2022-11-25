require 'rails_helper'

RSpec.describe 'Api::V1::Tasks', type: :request do
  # GET /api/v1/tasks/:id(.json) タスク詳細API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'GET #show' do
    subject { get api_v1_show_task_path(id: task.id, format: :json), headers: auth_headers }

    shared_context 'タスク作成' do
      let_it_be(:current_user) { FactoryBot.create(:user) }
      let_it_be(:task) { FactoryBot.create(:task) }
    end

    # テスト内容
    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)['task']
        expect(response_json['id']).to eq(task.id)
        expect(response_json['title']).to eq(task.title)
        expect(response_json['summary']).to eq(task.summary)
        expect(response_json['body']).to eq(task.body)
        expect(response_json['image_url']['large']).to eq("#{task.image_url(:large)}")
        expect(response_json['image_url']['xlarge']).to eq("#{task.image_url(:xlarge)}")
        expect(response_json['image_url']['xxlarge']).to eq("#{task.image_url(:xxlarge)}")
        expect(response_json['is_completed']).to eq(auth_headers.present? ? current_user&.task_complete?(task) : nil)
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
