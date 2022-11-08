# == Schema Information
#
# Table name: families
#
#  id                  :bigint           not null, primary key
#  age(年代)           :integer          default(0), not null
#  sex(性別)           :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id(ユーザーID) :bigint           not null
#
# Indexes
#
#  index_families_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Family, type: :model do
  describe "correct_family" do
    let(:user) { create(:user) }
    let(:family) { build(:family, user: user) }

    it "緊急時連絡先が正しく作成されていること" do
      expect(family).to be_valid
    end
  end

  describe "validate presence" do
    context "sexがNULLの時" do
      let(:family) { build(:family, sex: nil) }
      it "エラーメッセージが返る" do
        family.valid?
        expect(family).to be_invalid
      end
    end

    context "ageがNULLの時" do
      let(:family) { build(:family, age: nil) }
      it "エラーメッセージが返る" do
        family.valid?
        expect(family).to be_invalid
      end
    end

    context "userがNULLの時" do
      let(:family) { build(:family, user: nil) }
      it "エラーメッセージが返る" do
        family.valid?
        expect(family).to be_invalid
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
