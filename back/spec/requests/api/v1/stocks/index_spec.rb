require 'rails_helper'

RSpec.describe 'Api::V1::Stocks', type: :request do
  # GET /api/v1/stocks(.json) 備蓄品一覧API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'GET #index' do
    subject { get api_v1_stocks_path(format: :json), headers: auth_headers }

    shared_context '家族一覧作成' do
      let_it_be(:current_user) { user }
      let_it_be(:families) { FactoryBot.create_list(:family, Settings['default_index_limit'], user_id: current_user.id) }
      let_it_be(:task_profile) { FactoryBot.create(:task_profile, user_id: current_user.id) }
    end

    # テスト内容
    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。件数・対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)['stocks']

        expect(response_json.count).to eq(TaskProfile.stock_tasks.pairs.count)
        (0..TaskProfile.stock_tasks.pairs.count - 1).each do |no|
          data = response_json[no]
          stock = TaskProfile.stock_tasks.pairs.to_a[no]
          expect(data['name']).to eq(stock[0])
          expect(data['value']).to eq(stock[1].to_s)
          # expect(data['count']).to eq(stock.count)
          expect(data['is_completed']).to eq(task_profile.stock_tasks.set?(stock[1]))
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
      include_context '家族一覧作成'
      it_behaves_like 'ToNot', false, 'devise.failure.unauthenticated', nil
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      include_context '家族一覧作成'
      it_behaves_like 'ToNot', false, 'devise.failure.unauthenticated', nil
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      include_context '家族一覧作成'
      it_behaves_like 'ToOK'
    end
  end
end
