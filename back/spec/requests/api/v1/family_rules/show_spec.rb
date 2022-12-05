require 'rails_helper'

RSpec.describe 'Api::V1::FamilyRules', type: :request do
  # GET /api/v1/family_rule(.json) 家族会議メモ詳細API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'GET #show' do
    subject { get api_v1_family_rule_path(format: :json), headers: auth_headers }

    shared_context '家族会議メモ作成' do
      let_it_be(:family_rule) { FactoryBot.create(:family_rule, user_id: user.id) }
    end

    # テスト内容
    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)['family_rule']
        expect(response_json['contact_means_memo']).to eq(family_rule.contact_means_memo)
        expect(response_json['refuge_memo']).to eq(family_rule.refuge_memo)
        expect(response_json['family_role_memo']).to eq(family_rule.family_role_memo)
        expect(response_json['emergency_measure_memo']).to eq(family_rule.emergency_measure_memo)
        expect(response_json['leave_home_memo']).to eq(family_rule.leave_home_memo)
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
      include_context '家族会議メモ作成'
      it_behaves_like 'ToNot', false, 'devise.failure.unauthenticated', nil
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      include_context '家族会議メモ作成'
      it_behaves_like 'ToNot', false, 'devise.failure.unauthenticated', nil
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      include_context '家族会議メモ作成'
      it_behaves_like 'ToOK'
    end
  end
end
