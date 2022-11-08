require 'rails_helper'

RSpec.describe Api::V1::FamilyRulesController, type: :request do
  describe 'POST /api/v1/family_rules/update' do
    subject(:call_api) { post "/api/v1/family_rules/update.json", headers: headers, params: params }

    let(:user) { create :confirmed_user }
    let(:user2) { create :confirmed_user, username: 'test_name' }
    let(:headers) { user.create_new_auth_token }
    let(:family_rule) { create :family_rule, user_id: user.id }
    let(:params) {{ }}

    context 'ログインユーザーと投稿ユーザーが一致している場合' do
      context '投稿の更新に成功した場合' do
        let(:params) do
          {
            family_rule: {
              contact_means_memo: 'update_family_rule_contact_means_memo',
              emergency_measure_memo: 'update_family_rule_emergency_measure_memo',
              family_role_memo: 'update_family_rule_family_role_memo',
              leave_home_memo: 'update_family_rule_leave_home_memo',
              refuge_memo: 'update_family_rule_refuge_memo',
              user_id: user.id
            }
          }
        end

        it 'レスポンスステータスが200で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(true)
          expect(response.status).to eq 200
        end

        it 'レスポンスボディーに期待された値が返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['user']['id']).to eq user.id
        end
      end

      context '投稿の更新に失敗した場合' do
        let(:params) do
          {
            family_rule: {
              contact_means_memo: '',
              emergency_measure_memo: '',
              family_role_memo: '',
              leave_home_memo: '',
              refuge_memo: '',
              user_id: user.id
            }
          }
        end

        it 'レスポンスステータスが422で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(false)
          expect(response.status).to eq 422
        end

        it 'エラーが返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(false)
          expect(res['alert']).to eq(I18n.t('alert.family_rule.update'))
        end
      end
    end
  end

  describe 'POST /api/v1/family_rules/delete' do
    subject(:call_api) { post "/api/v1/family_rules/delete.json", headers: headers }

    let(:user) { create :confirmed_user }
    let(:user2) { create :confirmed_user, username: 'test_name' }
    let(:headers) { user.create_new_auth_token }
    let(:family_rule) { create :family_rule, user_id: user.id }
    let!(:point_record) { create :point_record, user_id: user.id }

    context 'ログインユーザーと投稿ユーザーが一致している場合' do
      context '投稿の削除に成功した場合' do
        it 'レスポンスステータスが200で返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['success']).to eq(true)
          expect(response.status).to eq 200
        end

        it '投稿が削除されていること' do
          expect { call_api }.to change { FamilyRule.count }.by(0)
        end

        it 'レスポンスボディーに期待された値が返ること' do
          call_api
          res = JSON.parse(response.body)
          expect(res['notice']).to eq(I18n.t('notice.family_rule.destroy'))
        end
      end
    end
  end
end
