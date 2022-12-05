require 'rails_helper'

RSpec.describe 'Api::V1::Infomations', type: :request do
  # GET /api/v1/infomations/:id(.json) お知らせ詳細API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   対象: 全員, 自分, 他人
  #   開始日時: 過去, 未来
  #   終了日時: 過去, 未来, ない
  describe 'GET #show' do
    subject { get api_v1_infomation_path(id: infomation.id, format: :json), headers: auth_headers }
    let_it_be(:outside_user) { FactoryBot.create(:user) }

    shared_context 'お知らせ作成' do
      let_it_be(:infomation) { FactoryBot.create(:infomation, started_at: started_at, ended_at: ended_at, target: target, user_id: user_id) }
    end

    # テスト内容
    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)['infomation']
        expect(response_json['label']).to eq(infomation.label)
        expect(response_json['label_i18n']).to eq(infomation.label_i18n)
        expect(response_json['title']).to eq(infomation.title)
        expect(response_json['summary']).to eq(infomation.summary)
        expect(response_json['body']).to eq(infomation.body)
        expect(response_json['started_at']).to eq(I18n.l(infomation.started_at, format: :json))
        expect(response_json['ended_at']).to eq(I18n.l(infomation.ended_at, format: :json, default: nil))
        expect(response_json['target']).to eq(infomation.target)
      end
    end
    shared_examples_for 'ToNot' do |success, alert, notice|
      it 'HTTPステータスが404。対象項目が一致する' do
        is_expected.to eq(404)
        response_json = response.body.present? ? JSON.parse(response.body) : {}
        expect(response_json['success']).to eq(success)

        expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
        expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
      end
    end

    # テストケース
    shared_examples_for '[*][全員][過去]終了日時が過去' do
      let_it_be(:ended_at) { Time.current - 1.day }
      include_context 'お知らせ作成'
      it_behaves_like 'ToNot', false, 'errors.messages.infomation.ended', nil
    end
    shared_examples_for '[ログイン中][自分][過去]終了日時が過去' do
      let_it_be(:ended_at) { Time.current - 1.day }
      include_context 'お知らせ作成'
      it_behaves_like 'ToNot', nil, nil, nil
    end
    shared_examples_for '[APIログイン中][自分][過去]終了日時が過去' do
      let_it_be(:ended_at) { Time.current - 1.day }
      include_context 'お知らせ作成'
      it_behaves_like 'ToNot', false, 'errors.messages.infomation.ended', nil
    end
    shared_examples_for '[*][他人][過去]終了日時が過去' do
      let_it_be(:ended_at) { Time.current - 1.day }
      include_context 'お知らせ作成'
      it_behaves_like 'ToNot', nil, nil, nil
    end
    shared_examples_for '[*][*][未来]終了日時が過去' do
      let_it_be(:ended_at) { Time.current - 1.day }
      include_context 'お知らせ作成'
      it_behaves_like 'ToNot', nil, nil, nil
    end
    shared_examples_for '[*][全員][過去]終了日時が未来' do
      let_it_be(:ended_at) { Time.current + 1.day }
      include_context 'お知らせ作成'
      it_behaves_like 'ToOK'
    end
    shared_examples_for '[ログイン中][自分][過去]終了日時が未来' do
      let_it_be(:ended_at) { Time.current + 1.day }
      include_context 'お知らせ作成'
      it_behaves_like 'ToNot', nil, nil, nil
    end
    shared_examples_for '[APIログイン中][自分][過去]終了日時が未来' do
      let_it_be(:ended_at) { Time.current + 1.day }
      include_context 'お知らせ作成'
      it_behaves_like 'ToOK'
    end
    shared_examples_for '[*][他人][過去]終了日時が未来' do
      let_it_be(:ended_at) { Time.current + 1.day }
      include_context 'お知らせ作成'
      it_behaves_like 'ToNot', nil, nil, nil
    end
    shared_examples_for '[*][*][未来]終了日時が未来' do
      let_it_be(:ended_at) { Time.current + 1.day }
      include_context 'お知らせ作成'
      it_behaves_like 'ToNot', nil, nil, nil
    end
    shared_examples_for '[*][全員][過去]終了日時がない' do
      let_it_be(:ended_at) { nil }
      include_context 'お知らせ作成'
      it_behaves_like 'ToOK'
    end
    shared_examples_for '[ログイン中][自分][過去]終了日時がない' do
      let_it_be(:ended_at) { nil }
      include_context 'お知らせ作成'
      it_behaves_like 'ToNot', nil, nil, nil
    end
    shared_examples_for '[APIログイン中][自分][過去]終了日時がない' do
      let_it_be(:ended_at) { nil }
      include_context 'お知らせ作成'
      it_behaves_like 'ToOK'
    end
    shared_examples_for '[*][他人][過去]終了日時がない' do
      let_it_be(:ended_at) { nil }
      include_context 'お知らせ作成'
      it_behaves_like 'ToNot', nil, nil, nil
    end
    shared_examples_for '[*][*][未来]終了日時がない' do
      let_it_be(:ended_at) { nil }
      include_context 'お知らせ作成'
      it_behaves_like 'ToNot', nil, nil, nil
    end

    shared_examples_for '[*][全員]開始日時が過去' do
      let_it_be(:started_at) { Time.current - 1.day }
      it_behaves_like '[*][全員][過去]終了日時が過去'
      it_behaves_like '[*][全員][過去]終了日時が未来'
      it_behaves_like '[*][全員][過去]終了日時がない'
    end
    shared_examples_for '[ログイン中][自分]開始日時が過去' do
      let_it_be(:started_at) { Time.current - 1.day }
      it_behaves_like '[ログイン中][自分][過去]終了日時が過去'
      it_behaves_like '[ログイン中][自分][過去]終了日時が未来'
      it_behaves_like '[ログイン中][自分][過去]終了日時がない'
    end
    shared_examples_for '[APIログイン中][自分]開始日時が過去' do
      let_it_be(:started_at) { Time.current - 1.day }
      it_behaves_like '[APIログイン中][自分][過去]終了日時が過去'
      it_behaves_like '[APIログイン中][自分][過去]終了日時が未来'
      it_behaves_like '[APIログイン中][自分][過去]終了日時がない'
    end
    shared_examples_for '[*][他人]開始日時が過去' do
      let_it_be(:started_at) { Time.current - 1.day }
      it_behaves_like '[*][他人][過去]終了日時が過去'
      it_behaves_like '[*][他人][過去]終了日時が未来'
      it_behaves_like '[*][他人][過去]終了日時がない'
    end
    shared_examples_for '[*][*]開始日時が未来' do
      let_it_be(:started_at) { Time.current + 1.day }
      it_behaves_like '[*][*][未来]終了日時が過去'
      it_behaves_like '[*][*][未来]終了日時が未来'
      it_behaves_like '[*][*][未来]終了日時がない'
    end

    shared_examples_for '[*]対象が全員' do
      let_it_be(:target)  { :all }
      let_it_be(:user_id) { nil }
      it_behaves_like '[*][全員]開始日時が過去'
      it_behaves_like '[*][*]開始日時が未来'
    end
    shared_examples_for '[ログイン中]対象が自分' do
      let_it_be(:target)  { :user }
      let_it_be(:user_id) { user.id }
      it_behaves_like '[ログイン中][自分]開始日時が過去'
      it_behaves_like '[*][*]開始日時が未来'
    end
    shared_examples_for '[APIログイン中]対象が自分' do
      let_it_be(:target)  { :user }
      let_it_be(:user_id) { user.id }
      it_behaves_like '[APIログイン中][自分]開始日時が過去'
      it_behaves_like '[*][*]開始日時が未来'
    end
    shared_examples_for '[*]対象が他人' do
      let_it_be(:target)  { :user }
      let_it_be(:user_id) { outside_user.id }
      it_behaves_like '[*][他人]開始日時が過去'
      it_behaves_like '[*][*]開始日時が未来'
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[*]対象が全員'
      it_behaves_like '[*]対象が他人'
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      it_behaves_like '[*]対象が全員'
      it_behaves_like '[ログイン中]対象が自分'
      it_behaves_like '[*]対象が他人'
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[*]対象が全員'
      it_behaves_like '[APIログイン中]対象が自分'
      it_behaves_like '[*]対象が他人'
    end
  end
end
