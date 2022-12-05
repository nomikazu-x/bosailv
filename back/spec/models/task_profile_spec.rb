# == Schema Information
#
# Table name: task_profiles
#
#  id                                              :bigint           not null, primary key
#  hazard_map_confirmed_at(ハザードマップ確認日時) :datetime
#  house_tasks(家庭関係防災タスク)                 :bigint           default(0), not null
#  sns_tasks(SNS関係防災タスク)                    :bigint           default(0), not null
#  stock_tasks(備蓄関係防災タスク)                 :bigint           default(0), not null
#  created_at                                      :datetime         not null
#  updated_at                                      :datetime         not null
#  user_id(ユーザーID)                             :bigint           not null
#
# Indexes
#
#  index_task_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe TaskProfile, type: :model do
  # テスト内容（共通）
  shared_examples_for 'Valid' do
    it '保存できる' do
      expect(task_profile).to be_valid
    end
  end
  shared_examples_for 'InValid' do
    it '保存できない' do
      expect(task_profile).to be_invalid
    end
  end

  # ハザードマップ確認済みか返却
  # 前提条件
  #   なし
  # テストパターン
  #   ハザードマップ確認日時: ない, ある
  describe '#destroy_reserved?' do
    subject { task_profile.hazard_map_confirmed? }
    let(:task_profile) { FactoryBot.build_stubbed(:task_profile, hazard_map_confirmed_at: hazard_map_confirmed_at) }

    context 'ハザードマップ確認日時がない' do
      let(:hazard_map_confirmed_at) { nil }
      it 'false' do
        is_expected.to eq(false)
      end
    end
    context 'ハザードマップ確認日時日時がある' do
      let(:hazard_map_confirmed_at) { Time.current }
      it 'true' do
        is_expected.to eq(true)
      end
    end
  end

  # ハザードマップ確認
  # 前提条件
  #   ハザードマップ確認日時なし
  # テストパターン
  #   なし
  describe '#set_hazard_map_confirm' do
    subject { task_profile.set_hazard_map_confirm }
    let_it_be(:task_profile) { FactoryBot.create(:task_profile) }

    context 'ハザードマップ確認日時' do
      let!(:start_time) { Time.current.floor }
      it 'ありに変更される' do
        is_expected.to eq(true)
        expect(task_profile.hazard_map_confirmed_at).to be_between(start_time, Time.current)
      end
    end
  end
end
