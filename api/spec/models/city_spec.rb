# == Schema Information
#
# Table name: cities
#
#  id                        :bigint           not null, primary key
#  name(市区町村名)          :string(255)      not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  prefecture_id(都道府県ID) :bigint           not null
#
# Indexes
#
#  index_cities_on_prefecture_id  (prefecture_id)
#
# Foreign Keys
#
#  fk_rails_...  (prefecture_id => prefectures.id)
#
require 'rails_helper'

RSpec.describe City, type: :model do
  describe "correct_city" do
    let(:prefecture) { create(:prefecture) }
    let(:city) { build(:city, prefecture: prefecture) }

    it "市区町村が正しく作成されていること" do
      expect(city).to be_valid
    end
  end

  describe "validate presence" do
    context "nameがNULLの時" do
      let(:city) { build(:city, name: nil) }
      it "エラーメッセージが返る" do
        city.valid?
        expect(city).to be_invalid
      end
    end

    context "prefectureがNULLの時" do
      let(:city) { build(:city, prefecture: nil) }
      it "エラーメッセージが返る" do
        city.valid?
        expect(city).to be_invalid
      end
    end
  end

  describe "association" do
    it "Prefectureテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:prefecture)
      expect(rel.macro).to eq :belongs_to
    end
  end
end
