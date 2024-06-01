# == Schema Information
#
# Table name: family_rules
#
#  id                                     :bigint           not null, primary key
#  contact_means_memo(緊急時連絡手段メモ) :text(65535)      not null
#  emergency_measure_memo(応急処置メモ)   :text(65535)      not null
#  family_role_memo(家族の役割分担メモ)   :text(65535)      not null
#  leave_home_memo(家を離れるときメモ)    :text(65535)      not null
#  refuge_memo(避難方法メモ)              :text(65535)      not null
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  user_id(ユーザーID)                    :bigint           not null
#
# Indexes
#
#  index_family_rules_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe FamilyRule, type: :model do
  # テスト内容（共通）
  shared_examples_for 'Valid' do
    it '保存できる' do
      expect(family_rule).to be_valid
    end
  end
  shared_examples_for 'InValid' do
    it '保存できない' do
      expect(family_rule).to be_invalid
    end
  end

  # 緊急時連絡手段メモ
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 最大文字数と同じ, 最大文字数よりも多い
  describe 'validates :contact_means_memo' do
    let(:family_rule) { FactoryBot.build_stubbed(:family_rule, contact_means_memo: contact_means_memo) }

    # テストケース
    context 'ない' do
      let(:contact_means_memo) { nil }
      it_behaves_like 'InValid'
    end
    context '最大文字数と同じ' do
      let(:contact_means_memo) { 'a' * Settings['family_rule_contact_means_memo_maximum'] }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:contact_means_memo) { 'a' * (Settings['family_rule_contact_means_memo_maximum'] + 1) }
      it_behaves_like 'InValid'
    end
  end

  # 応急処置メモ
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 最大文字数と同じ, 最大文字数よりも多い
  describe 'validates :emergency_measure_memo' do
    let(:family_rule) { FactoryBot.build_stubbed(:family_rule, emergency_measure_memo: emergency_measure_memo) }

    # テストケース
    context 'ない' do
      let(:emergency_measure_memo) { nil }
      it_behaves_like 'InValid'
    end
    context '最大文字数と同じ' do
      let(:emergency_measure_memo) { 'a' * (Settings['family_rule_emergency_measure_memo_maximum']) }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:emergency_measure_memo) { 'a' * (Settings['family_rule_emergency_measure_memo_maximum'] + 1) }
      it_behaves_like 'InValid'
    end
  end

  # 家族の役割分担メモ
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 最大文字数と同じ, 最大文字数よりも多い
  describe 'validates :family_role_memo' do
    let(:family_rule) { FactoryBot.build_stubbed(:family_rule, family_role_memo: family_role_memo) }

    # テストケース
    context 'ない' do
      let(:family_role_memo) { nil }
      it_behaves_like 'InValid'
    end
    context '最大文字数と同じ' do
      let(:family_role_memo) { 'a' * (Settings['family_rule_family_role_memo_maximum']) }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:family_role_memo) { 'a' * (Settings['family_rule_family_role_memo_maximum'] + 1) }
      it_behaves_like 'InValid'
    end
  end

  # 家を離れるときメモ
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 最大文字数と同じ, 最大文字数よりも多い
  describe 'validates :leave_home_memo' do
    let(:family_rule) { FactoryBot.build_stubbed(:family_rule, leave_home_memo: leave_home_memo) }

    # テストケース
    context 'ない' do
      let(:leave_home_memo) { nil }
      it_behaves_like 'InValid'
    end
    context '最大文字数と同じ' do
      let(:leave_home_memo) { 'a' * (Settings['family_rule_leave_home_memo_maximum']) }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:leave_home_memo) { 'a' * (Settings['family_rule_leave_home_memo_maximum'] + 1) }
      it_behaves_like 'InValid'
    end
  end

  # 避難方法メモ
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 最大文字数と同じ, 最大文字数よりも多い
  describe 'validates :refuge_memo' do
    let(:family_rule) { FactoryBot.build_stubbed(:family_rule, refuge_memo: refuge_memo) }

    # テストケース
    context 'ない' do
      let(:refuge_memo) { nil }
      it_behaves_like 'InValid'
    end
    context '最大文字数と同じ' do
      let(:refuge_memo) { 'a' * (Settings['family_rule_refuge_memo_maximum']) }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:refuge_memo) { 'a' * (Settings['family_rule_refuge_memo_maximum'] + 1) }
      it_behaves_like 'InValid'
    end
  end
end
