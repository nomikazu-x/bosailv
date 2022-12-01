require 'rails_helper'

RSpec.describe 'Api::V1::Admin::Tasks', type: :request do
  # POST /api/v1/admin/tasks/:id/update(.json) ジャンル更新API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中, 管理者APIログイン中
  #   無効なパラメータ, 有効なパラメータ
  describe 'POST #update' do
    subject { post api_v1_admin_update_task_path(id: task.id, format: :json), params: attributes, headers: auth_headers }
    let_it_be(:task) { FactoryBot.create(:task) }
    let(:valid_attributes) { { task: { title: task[:title], image: task[:image], summary: task[:summary], body: task[:body], icon: task[:icon] } } }
    let(:invalid_attributes) { { task: { title: nil, image: nil, summary: nil, body: nil, icon: nil } } }

    # テスト内容
    shared_examples_for 'OK' do
      it '更新される。' do
        expect do
          subject
          target_task = Task.find(task.id)
          expect(target_task.title).to eq(attributes[:title])
          expect(target_task.summary).to eq(attributes[:summary])
          expect(target_task.body).to eq(attributes[:body])
          expect(target_task.image).to eq(attributes[:image])
          expect(target_task.icon).to eq(attributes[:icon])
        end
      end
    end

    shared_examples_for 'NG' do
      it '更新されない。' do
        expect do
          subject
          target_task = Task.find(task.id)
          expect(target_task.title).to eq(task.title)
          expect(target_task.summary).to eq(task.summary)
          expect(target_task.body).to eq(task.body)
          expect(target_task.image).to eq(task.image)
          expect(target_task.icon).to eq(task.icon)
        end
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
    shared_examples_for '[未ログイン/ログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'errors.messages.not_permission', nil
    end

    shared_examples_for '[管理者APIログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 422, false, 'alert.task.update', nil
    end

    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'errors.messages.not_permission', nil
    end

    shared_examples_for '[管理者APIログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'OK'
      it_behaves_like 'ToMsg', 200, true, nil, 'notice.task.update'
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
    end

    context 'ログイン中' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
    end

    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[APIログイン中]無効なパラメータ'
      it_behaves_like '[APIログイン中]有効なパラメータ'
    end

    context '管理者APIログイン中' do
      include_context 'APIログイン処理', :admin
      it_behaves_like '[管理者APIログイン中]無効なパラメータ'
      it_behaves_like '[管理者APIログイン中]有効なパラメータ'
    end
  end
end
