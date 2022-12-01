require 'rails_helper'

RSpec.describe 'Api::V1::FamilyRules', type: :request do
  # POST /api/v1/family_rules/:id/update (.json) 記事更新API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中, 管理者APIログイン中
  #   無効なパラメータ, 有効なパラメータ
  describe 'POST #update' do
    subject { post api_v1_update_family_rule_path(id: family_rule.id, format: :json), params: attributes, headers: auth_headers }
    let!(:family_rule) { FactoryBot.create(:family_rule, user: user) }
    let(:valid_attributes) { { family_rule: { contact_means_memo: family_rule[:contact_means_memo], emergency_measure_memo: family_rule[:emergency_measure_memo], family_role_memo: family_rule[:family_role_memo], leave_home_memo: family_rule[:leave_home_memo], refuge_memo: family_rule[:refuge_memo] } } }
    let(:invalid_attributes) { { family_rule: { contact_means_memo: nil, emergency_measure_memo: nil, family_role_memo: nil, leave_home_memo: nil, refuge_memo: nil } } }
    let(:current_user) { user }

    # テスト内容
    shared_examples_for 'OK' do
      it '更新される。' do
        expect do
          subject
          target_family_rule = FamilyRule.find(family_rule.id)
          expect(target_family_rule.contact_means_memo).to eq(attributes[:contact_means_memo])
          expect(target_family_rule.emergency_measure_memo).to eq(attributes[:emergency_measure_memo])
          expect(target_family_rule.family_role_memo).to eq(attributes[:family_role_memo])
          expect(target_family_rule.leave_home_memo).to eq(attributes[:leave_home_memo])
        end
      end
    end

    shared_examples_for 'NG' do
      it '更新されない。' do
        expect do
          subject
          target_family_rule = FamilyRule.find(family_rule.id)
          expect(target_family_rule.contact_means_memo).to eq(family_rule.contact_means_memo)
          expect(target_family_rule.emergency_measure_memo).to eq(family_rule.emergency_measure_memo)
          expect(target_family_rule.family_role_memo).to eq(family_rule.family_role_memo)
          expect(target_family_rule.family_role_memo).to eq(family_rule.family_role_memo)
          expect(target_family_rule.leave_home_memo).to eq(family_rule.leave_home_memo)
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
      it_behaves_like 'ToMsg', 422, false, 'alert.family_rule.update', nil
    end

    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 200, true, nil, 'notice.family_rule.update'
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
  end
end
