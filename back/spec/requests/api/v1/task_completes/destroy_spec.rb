require 'rails_helper'

RSpec.describe 'Api::V1::TaskCompletes', type: :request do
  # POST /api/v1/tasks/:id/task_completes/delete(.json) タスク未完了API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'POST #destroy' do
    subject { post api_v1_uncomplete_task_path(id: task.id, format: :json), headers: auth_headers }
    let_it_be(:task) { FactoryBot.create(:task) }
    let!(:task_complete) { FactoryBot.create(:task_complete, task: task, user: user) }
    let!(:point_record) { FactoryBot.create(:point_record, user: user, obtained_point: Settings['task_complete_obtained_point']) }
    let(:current_user) { user }

    # テスト内容
    shared_examples_for 'OK' do
      it '削除される' do
        expect { subject }.to change(TaskComplete, :count).by(-1) && change(PointRecord, :count).by(-1)
      end
    end
    shared_examples_for 'NG' do
      it '削除されない' do
        expect { subject }.to change(TaskComplete, :count).by(0) && change(PointRecord, :count).by(0)
      end
    end

    shared_examples_for 'ToMsg' do |code, success, alert, notice|
      it "HTTPステータスが#{code}。対象項目が一致する。" do
        is_expected.to eq(code)
        response_json = response.body.present? ? JSON.parse(response.body) : {}
        expect(response_json['success']).to eq(success)

        expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
        expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
      end
    end

    # テストケース
    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    context 'ログイン中' do
      include_context '未ログイン処理'
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like 'OK'
      it_behaves_like 'ToMsg', 200, true, nil, 'notice.task_complete.destroy'
    end
  end
end
