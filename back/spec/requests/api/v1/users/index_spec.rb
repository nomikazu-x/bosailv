require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  # GET /api/v1/users(.json) ユーザー一覧API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   ユーザー: 最大表示数と同じ, 最大表示数より多い
  describe 'GET #index' do
    subject { get api_v1_users_path(page: subject_page, format: :json), headers: auth_headers }

    shared_context 'ユーザー一覧作成' do |default_users_count|
      let_it_be(:users) { FactoryBot.create_list(:user, default_users_count - 1) } # Tips: ログインユーザーも作成されるため、-1する。
    end

    # テスト内容
    shared_examples_for 'ToOK' do |page|
      let(:subject_page) { page }
      it 'HTTPステータスが200。対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)['user']
        # expect(response_json['total_count']).to eq(users.count)
        expect(response_json['current_page']).to eq(subject_page)
        # expect(response_json['total_pages']).to eq((users.count - 1).div(Settings['default_users_limit']) + 1)
        expect(response_json['limit_value']).to eq(Settings['default_users_limit'])
      end
    end

    shared_examples_for 'リスト表示' do |page|
      let(:subject_page) { page }
      let(:start_no)     { (Settings['default_users_limit'] * (page - 1)) + 1 }
      let(:end_no)       { [users.count, Settings['default_users_limit'] * page].min }
      it '件数・対象項目が一致する' do
        subject
        response_json = JSON.parse(response.body)['users']
        # expect(response_json.count).to eq(end_no - start_no + 1)
        (start_no..end_no).each do |no|
          data = response_json[no - start_no]
          user = users[users.count - no]
          expect(data['id']).to eq(user.id)
          expect(data['name']).to eq(user.name)
          expect(data['level']).to eq(user.level)
          expect(data['username']).to eq(user.username)
          expect(data['lifelong_point']).to eq(user.lifelong_point)
          expect(data['image_url']['mini']).to eq("#{user.image_url(:mini)}")
          expect(data['image_url']['small']).to eq("#{user.image_url(:small)}")
          expect(data['image_url']['medium']).to eq("#{user.image_url(:medium)}")
          expect(data['image_url']['large']).to eq("#{user.image_url(:large)}")
          expect(data['image_url']['xlarge']).to eq("#{user.image_url(:xlarge)}")
        end
      end
    end

    # テストケース
    shared_examples_for '[未ログイン]ユーザーが最大表示数と同じ' do
      include_context 'ユーザー一覧作成', Settings['default_users_limit']
      it_behaves_like 'ToOK', 1
      it_behaves_like 'リスト表示', 1
    end
    shared_examples_for '[ログイン中]ユーザーが最大表示数と同じ' do
      include_context 'ユーザー一覧作成', Settings['default_users_limit']
      it_behaves_like 'ToOK', 1
      it_behaves_like 'リスト表示', 1
    end
    shared_examples_for '[APIログイン中]ユーザーが最大表示数と同じ' do
      include_context 'ユーザー一覧作成', Settings['default_users_limit']
      it_behaves_like 'ToOK', 1
      it_behaves_like 'リスト表示', 1
    end
    shared_examples_for '[未ログイン]ユーザーが最大表示数より多い' do
      include_context 'ユーザー一覧作成', Settings['default_users_limit'] + 1
      it_behaves_like 'ToOK', 1
      it_behaves_like 'ToOK', 2
      it_behaves_like 'リスト表示', 1
      it_behaves_like 'リスト表示', 2
    end
    shared_examples_for '[ログイン中]ユーザーが最大表示数より多い' do
      include_context 'ユーザー一覧作成', Settings['default_users_limit'] + 1
      it_behaves_like 'ToOK', 1
      it_behaves_like 'ToOK', 2
      it_behaves_like 'リスト表示', 1
      it_behaves_like 'リスト表示', 2
    end
    shared_examples_for '[APIログイン中]ユーザーが最大表示数より多い' do
      include_context 'ユーザー一覧作成', Settings['default_users_limit'] + 1
      it_behaves_like 'ToOK', 1
      it_behaves_like 'ToOK', 2
      it_behaves_like 'リスト表示', 1
      it_behaves_like 'リスト表示', 2
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン]ユーザーが最大表示数と同じ'
      it_behaves_like '[未ログイン]ユーザーが最大表示数より多い'
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      it_behaves_like '[ログイン中]ユーザーが最大表示数と同じ'
      it_behaves_like '[ログイン中]ユーザーが最大表示数より多い'
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[APIログイン中]ユーザーが最大表示数と同じ'
      it_behaves_like '[APIログイン中]ユーザーが最大表示数より多い'
    end
  end
end
