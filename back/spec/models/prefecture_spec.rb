# == Schema Information
#
# Table name: prefectures
#
#  id               :bigint           not null, primary key
#  name(都道府県名) :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_prefectures_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Prefecture, type: :model do
  describe "correct_prefecture" do
    let(:prefecture) { build(:prefecture) }

    it "都道府県が正しく作成されていること" do
      expect(prefecture).to be_valid
    end
  end

  describe "validate presence" do
    context "nameがNULLの時" do
      let(:prefecture) { build(:prefecture, name: nil) }
      it "エラーメッセージが返る" do
        prefecture.valid?
        expect(prefecture).to be_invalid
      end
    end
  end

  describe "association" do
    it "Cityテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:cities)
      expect(rel.macro).to eq :has_many
    end
  end
end
