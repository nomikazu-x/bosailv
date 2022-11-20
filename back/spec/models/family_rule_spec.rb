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
  describe "correct_family_rule" do
    let(:user) { create(:user) }
    let(:family_rule) { build(:family_rule, user: user) }

    it "緊急時連絡先が正しく作成されていること" do
      expect(family_rule).to be_valid
    end
  end

  describe "validate presence" do
    context "contact_means_memoがNULLの時" do
      let(:family_rule) { build(:family_rule, contact_means_memo: nil) }
      it "エラーメッセージが返る" do
        family_rule.valid?
        expect(family_rule).to be_invalid
      end
    end

    context "emergency_measure_memoがNULLの時" do
      let(:family_rule) { build(:family_rule, emergency_measure_memo: nil) }
      it "エラーメッセージが返る" do
        family_rule.valid?
        expect(family_rule).to be_invalid
      end
    end

    context "family_role_memoがNULLの時" do
      let(:family_rule) { build(:family_rule, family_role_memo: nil) }
      it "エラーメッセージが返る" do
        family_rule.valid?
        expect(family_rule).to be_invalid
      end
    end

    context "leave_home_memoがNULLの時" do
      let(:family_rule) { build(:family_rule, leave_home_memo: nil) }
      it "エラーメッセージが返る" do
        family_rule.valid?
        expect(family_rule).to be_invalid
      end
    end

    context "refuge_memoがNULLの時" do
      let(:family_rule) { build(:family_rule, refuge_memo: nil) }
      it "エラーメッセージが返る" do
        family_rule.valid?
        expect(family_rule).to be_invalid
      end
    end

    context "userがNULLの時" do
      let(:family_rule) { build(:family_rule, user: nil) }
      it "エラーメッセージが返る" do
        family_rule.valid?
        expect(family_rule).to be_invalid
      end
    end
  end

  describe "association" do
    it "Userテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:user)
      expect(rel.macro).to eq :belongs_to
    end
  end
end
