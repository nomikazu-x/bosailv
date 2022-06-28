# == Schema Information
#
# Table name: point_records
#
#  id                         :bigint           not null, primary key
#  obtained_point(獲得経験値) :integer          not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  user_id(ユーザーID)        :bigint           not null
#
# Indexes
#
#  index_point_records_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe PointRecord, type: :model do
  describe "correct_point_record" do
    let(:user) { create(:user) }
    let(:point_record) { build(:point_record, user: user) }

    it "正しく作成されていること" do
      expect(point_record).to be_valid
    end
  end

  describe "validate presence" do
    context "obtained_pointがNULLの時" do
      let(:point_record) { build(:point_record, obtained_point: nil) }
      it "エラーメッセージが返る" do
        point_record.valid?
        expect(point_record).to be_invalid
      end
    end

    context "userがNULLの時" do
      let(:point_record) { build(:point_record, user: nil) }
      it "エラーメッセージが返る" do
        point_record.valid?
        expect(point_record).to be_invalid
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
