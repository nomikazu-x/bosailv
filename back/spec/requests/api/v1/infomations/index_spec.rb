require 'rails_helper'

RSpec.describe 'Api::V1::Infomations', type: :request do
  # GET /api/v1/infomations(.json) お知らせ一覧API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   お知らせ: ない, 最大表示数と同じ, 最大表示数より多い
  describe 'GET #index' do
    subject { get api_v1_infomations_path(page: subject_page, format: :json), headers: auth_headers }

    # テスト内容
    shared_examples_for 'ToOK' do |page|
      let(:subject_page) { page }
      it 'HTTPステータスが200。対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)['infomation']
        expect(response_json['total_count']).to eq(infomations.count)
        expect(response_json['current_page']).to eq(subject_page)
        expect(response_json['total_pages']).to eq((infomations.count - 1).div(Settings['default_infomations_limit']) + 1)
        expect(response_json['limit_value']).to eq(Settings['default_infomations_limit'])
      end
    end

    shared_examples_for 'リスト表示' do |page|
      let(:subject_page) { page }
      let(:start_no)     { (Settings['default_infomations_limit'] * (page - 1)) + 1 }
      let(:end_no)       { [infomations.count, Settings['default_infomations_limit'] * page].min }
      it '件数・対象項目が一致する' do
        subject
        response_json = JSON.parse(response.body)['infomations']
        expect(response_json.count).to eq(end_no - start_no + 1)
        (start_no..end_no).each do |no|
          data = response_json[no - start_no]
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
    shared_examples_for '[*]お知らせがない' do
      include_context 'お知らせ一覧作成', 0, 0, 0, 0
      it_behaves_like 'ToOK', 1
    end
    shared_examples_for '[未ログイン]お知らせが最大表示数と同じ' do
      count = Settings['test_infomations']
      include_context 'お知らせ一覧作成', count['all_forever_count'] + count['user_forever_count'], count['all_future_count'] + count['user_future_count'], 0, 0
      it_behaves_like 'ToOK', 1
      it_behaves_like 'リスト表示', 1
    end
    shared_examples_for '[ログイン中]お知らせが最大表示数と同じ' do
      count = Settings['test_infomations']
      include_context 'お知らせ一覧作成', count['all_forever_count'], count['all_future_count'], count['user_forever_count'], count['user_future_count']
      it_behaves_like 'ToOK', 1
      it_behaves_like 'リスト表示', 1
    end
    shared_examples_for '[APIログイン中]お知らせが最大表示数と同じ' do
      count = Settings['test_infomations']
      include_context 'お知らせ一覧作成', count['all_forever_count'], count['all_future_count'], count['user_forever_count'], count['user_future_count']
      it_behaves_like 'ToOK', 1
      it_behaves_like 'リスト表示', 1
    end
    shared_examples_for '[未ログイン]お知らせが最大表示数より多い' do
      count = Settings['test_infomations']
      include_context 'お知らせ一覧作成', count['all_forever_count'] + count['user_forever_count'], count['all_future_count'] + count['user_future_count'] + 1, 0, 0
      it_behaves_like 'ToOK', 1
      it_behaves_like 'ToOK', 2
      it_behaves_like 'リスト表示', 1
      it_behaves_like 'リスト表示', 2
    end
    shared_examples_for '[ログイン中]お知らせが最大表示数より多い' do
      count = Settings['test_infomations']
      include_context 'お知らせ一覧作成', count['all_forever_count'], count['all_future_count'], count['user_forever_count'], count['user_future_count'] + 1
      it_behaves_like 'ToOK', 1
      it_behaves_like 'ToOK', 2
      it_behaves_like 'リスト表示', 1
      # it_behaves_like 'リスト表示', 2
    end
    shared_examples_for '[APIログイン中]お知らせが最大表示数より多い' do
      count = Settings['test_infomations']
      include_context 'お知らせ一覧作成', count['all_forever_count'], count['all_future_count'], count['user_forever_count'], count['user_future_count'] + 1
      it_behaves_like 'ToOK', 1
      it_behaves_like 'ToOK', 2
      it_behaves_like 'リスト表示', 1
      it_behaves_like 'リスト表示', 2
    end

    context '未ログイン' do
      let(:infomations) { @all_infomations }
      include_context '未ログイン処理'
      it_behaves_like '[*]お知らせがない'
      it_behaves_like '[未ログイン]お知らせが最大表示数と同じ'
      it_behaves_like '[未ログイン]お知らせが最大表示数より多い'
    end
    context 'ログイン中' do
      let(:infomations) { @all_infomations }
      include_context 'ログイン処理'
      it_behaves_like '[*]お知らせがない'
      it_behaves_like '[ログイン中]お知らせが最大表示数と同じ'
      it_behaves_like '[ログイン中]お知らせが最大表示数より多い'
    end
    context 'APIログイン中' do
      let(:infomations) { @user_infomations }
      include_context 'APIログイン処理'
      it_behaves_like '[*]お知らせがない'
      it_behaves_like '[APIログイン中]お知らせが最大表示数と同じ'
      it_behaves_like '[APIログイン中]お知らせが最大表示数より多い'
    end
  end
end
