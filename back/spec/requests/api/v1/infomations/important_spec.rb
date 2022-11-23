require 'rails_helper'

RSpec.describe 'Api::V1::Infomations', type: :request do
  # GET /api/v1/infomations/important(.json) 大切なお知らせ一覧API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   大切なお知らせ: ない, ある
  describe 'GET #important' do
    subject { get api_v1_important_infomations_path(format: :json), headers: auth_headers }
    before_all { FactoryBot.create(:infomation, :important, :force_finished) }

    # テスト内容
    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)
      end
    end

    shared_examples_for 'リスト表示' do
      it '件数・対象項目が一致する' do
        subject
        response_json = JSON.parse(response.body)['infomations']
        expect(response_json.count).to eq(infomations.count)
        (1..infomations.count).each do |no|
          data = response_json[no - 1]
          infomation = infomations[infomations.count - no]
          expect(data['id']).to eq(infomation.id)
          expect(data['label']).to eq(infomation.label)
          expect(data['label_i18n']).to eq(infomation.label_i18n)
          expect(data['title']).to eq(infomation.title)
          expect(data['summary']).to eq(infomation.summary)
          expect(data['body_present']).to eq(infomation.body.present?)
          expect(data['started_at']).to eq(I18n.l(infomation.started_at, format: :json))
          expect(data['ended_at']).to eq(I18n.l(infomation.ended_at, format: :json, default: nil))
          expect(data['target']).to eq(infomation.target)
        end
      end
    end

    # テストケース
    shared_examples_for '[*]大切なお知らせがない' do
      include_context '大切なお知らせ一覧作成', 0, 0, 0, 0
      it_behaves_like 'ToOK'
      it_behaves_like 'リスト表示'
    end
    shared_examples_for '[未ログイン]大切なお知らせがある' do
      include_context '大切なお知らせ一覧作成', 1, 1, 0, 0
      it_behaves_like 'ToOK'
      it_behaves_like 'リスト表示'
    end
    shared_examples_for '[ログイン中/削除予約済み]大切なお知らせがある' do
      include_context '大切なお知らせ一覧作成', 1, 1, 1, 1
      it_behaves_like 'ToOK'
      it_behaves_like 'リスト表示'
    end

    context '未ログイン' do
      let(:infomations) { @all_important_infomations }
      include_context '未ログイン処理'
      include_context 'お知らせ一覧作成', 1, 1, 0, 0
      it_behaves_like '[*]大切なお知らせがない'
      it_behaves_like '[未ログイン]大切なお知らせがある'
    end
    context 'ログイン中' do
      let(:infomations) { @all_important_infomations }
      include_context 'ログイン処理'
      include_context 'お知らせ一覧作成', 1, 1, 1, 1
      it_behaves_like '[*]大切なお知らせがない'
      it_behaves_like '[ログイン中/削除予約済み]大切なお知らせがある'
    end
    context 'APIログイン中' do
      let(:infomations) { @user_important_infomations }
      include_context 'APIログイン処理'
      include_context 'お知らせ一覧作成', 1, 1, 1, 1
      it_behaves_like '[*]大切なお知らせがない'
      it_behaves_like '[ログイン中/削除予約済み]大切なお知らせがある'
    end
  end
end
