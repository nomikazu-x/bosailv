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
  describe "correct_task_profile" do
    let(:user) { create(:user) }
    let(:task_profile) { build(:task_profile, user: user) }

    it "ハザードマップが正しく作成されていること" do
      expect(task_profile).to be_valid
    end
  end

  describe "validate presence" do
    context "house_tasksがNULLの時" do
      let(:task_profile) { build(:task_profile, house_tasks: nil) }
      it "エラーメッセージが返る" do
        task_profile.valid?
        expect(task_profile).to be_invalid
      end
    end

    context "sns_tasksがNULLの時" do
      let(:task_profile) { build(:task_profile, sns_tasks: nil) }
      it "エラーメッセージが返る" do
        task_profile.valid?
        expect(task_profile).to be_invalid
      end
    end

    context "stock_tasksがNULLの時" do
      let(:task_profile) { build(:task_profile, stock_tasks: nil) }
      it "エラーメッセージが返る" do
        task_profile.valid?
        expect(task_profile).to be_invalid
      end
    end

    context "userがNULLの時" do
      let(:task_profile) { build(:task_profile, user: nil) }
      it "エラーメッセージが返る" do
        task_profile.valid?
        expect(task_profile).to be_invalid
      end
    end
  end

  describe "association" do
    it "userテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:user)
      expect(rel.macro).to eq :belongs_to
    end
  end
end
