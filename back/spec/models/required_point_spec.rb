# == Schema Information
#
# Table name: required_points
#
#  id                                    :bigint           not null, primary key
#  level(レベル)                         :integer          not null
#  lifelong_point(合計獲得ポイント)      :integer          not null
#  point(次のレベルまでに必要なポイント) :integer          not null
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#
require 'rails_helper'

RSpec.describe RequiredPoint, type: :model do
  describe "correct_required_point" do
    let(:required_point) { build(:required_point) }

    it "正しく作成されていること" do
      expect(required_point).to be_valid
    end
  end

  describe "validate presence" do
    context "levelがNULLの時" do
      let(:required_point) { build(:required_point, level: nil) }
      it "エラーメッセージが返る" do
        required_point.valid?
        expect(required_point).to be_invalid
      end
    end
    context "lifelong_pointがNULLの時" do
      let(:required_point) { build(:required_point, lifelong_point: nil) }
      it "エラーメッセージが返る" do
        required_point.valid?
        expect(required_point).to be_invalid
      end
    end
    context "pointがNULLの時" do
      let(:required_point) { build(:required_point, point: nil) }
      it "エラーメッセージが返る" do
        required_point.valid?
        expect(required_point).to be_invalid
      end
    end
  end
end
