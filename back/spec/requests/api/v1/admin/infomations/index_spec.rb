require 'rails_helper'

RSpec.describe 'Api::V1::Admin::Infomations', type: :request do
  # GET /api/v1/admin/infomations(.json) お知らせ一覧API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中, 管理者APIログイン中
  #   お知らせ: ない, 最大表示数と同じ, 最大表示数より多い
  describe 'GET #index' do
    subject { get api_v1_admin_infomations_path(page: subject_page, format: :json), headers: auth_headers }

    shared_context 'お知らせ作成' do |default_infomations_count|
      let_it_be(:infomations) { FactoryBot.create_list(:infomation, default_infomations_count) }
    end

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

    shared_examples_for 'ToNot' do |page, success, alert, notice|
      let(:subject_page) { page }
      it 'HTTPステータスが401。対象項目が一致する' do
        is_expected.to eq(401)
        response_json = response.body.present? ? JSON.parse(response.body) : {}
        expect(response_json['success']).to eq(success)

        expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
        expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
      end
    end

    # テストケース
    shared_examples_for '[未ログイン]お知らせがない' do
      include_context 'お知らせ作成', 0
      it_behaves_like 'ToNot', 1, false, 'devise.failure.unauthenticated', nil
    end
    shared_examples_for '[ログイン中]お知らせがない' do
      include_context 'お知らせ作成', 0
      it_behaves_like 'ToNot', 1, false, 'devise.failure.unauthenticated', nil
    end
    shared_examples_for '[APIログイン中]お知らせがない' do
      include_context 'お知らせ作成', 0
      it_behaves_like 'ToNot', 1, false, 'errors.messages.not_permission', nil
    end
    shared_examples_for '[管理者APIログイン中]お知らせがない' do
      include_context 'お知らせ作成', 0
      it_behaves_like 'ToOK', 1
    end
    shared_examples_for '[未ログイン]お知らせが最大表示数と同じ' do
      include_context 'お知らせ作成', Settings['default_infomations_limit']
      it_behaves_like 'ToNot', 1, false, 'devise.failure.unauthenticated', nil
    end
    shared_examples_for '[ログイン中]お知らせが最大表示数と同じ' do
      include_context 'お知らせ作成', Settings['default_infomations_limit']
      it_behaves_like 'ToNot', 1, false, 'devise.failure.unauthenticated', nil
    end
    shared_examples_for '[APIログイン中]お知らせが最大表示数と同じ' do
      include_context 'お知らせ作成', Settings['default_infomations_limit']
      it_behaves_like 'ToNot', 1, false, 'errors.messages.not_permission', nil
    end
    shared_examples_for '[管理者APIログイン中]お知らせが最大表示数と同じ' do
      include_context 'お知らせ作成', Settings['default_infomations_limit']
      it_behaves_like 'ToOK', 1
      it_behaves_like 'リスト表示', 1
    end
    shared_examples_for '[未ログイン]お知らせが最大表示数より多い' do
      include_context 'お知らせ作成', Settings['default_infomations_limit']
      it_behaves_like 'ToNot', 1, false, 'devise.failure.unauthenticated', nil
    end
    shared_examples_for '[ログイン中]お知らせが最大表示数より多い' do
      include_context 'お知らせ作成', Settings['default_infomations_limit'] + 1
      it_behaves_like 'ToNot', 1, false, 'devise.failure.unauthenticated', nil
    end
    shared_examples_for '[APIログイン中]お知らせが最大表示数より多い' do
      include_context 'お知らせ作成', Settings['default_infomations_limit'] + 1
      it_behaves_like 'ToNot', 1, false, 'errors.messages.not_permission', nil
    end
    shared_examples_for '[管理者APIログイン中]お知らせが最大表示数より多い' do
      include_context 'お知らせ作成', Settings['default_infomations_limit'] + 1
      it_behaves_like 'ToOK', 1
      it_behaves_like 'ToOK', 2
      it_behaves_like 'リスト表示', 1
      it_behaves_like 'リスト表示', 2
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン]お知らせがない'
      it_behaves_like '[未ログイン]お知らせが最大表示数と同じ'
      it_behaves_like '[未ログイン]お知らせが最大表示数より多い'
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      it_behaves_like '[ログイン中]お知らせがない'
      it_behaves_like '[ログイン中]お知らせが最大表示数と同じ'
      it_behaves_like '[ログイン中]お知らせが最大表示数より多い'
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[APIログイン中]お知らせがない'
      it_behaves_like '[APIログイン中]お知らせが最大表示数と同じ'
      it_behaves_like '[APIログイン中]お知らせが最大表示数より多い'
    end
    context '管理者APIログイン中' do
      include_context 'APIログイン処理', :admin
      it_behaves_like '[管理者APIログイン中]お知らせがない'
      it_behaves_like '[管理者APIログイン中]お知らせが最大表示数と同じ'
      it_behaves_like '[管理者APIログイン中]お知らせが最大表示数より多い'
    end
  end
end
