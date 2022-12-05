# == Schema Information
#
# Table name: hazard_maps
#
#  id                                      :bigint           not null, primary key
#  flood(洪水ハザードマップURL)            :text(65535)
#  inland_flood(内水氾濫ハザードマップURL) :text(65535)
#  landslide(土砂災害ハザードマップURL)    :text(65535)
#  reservoir(ため池ハザードマップURL)      :text(65535)
#  storm_surge(高潮ハザードマップURL)      :text(65535)
#  tsunami(津波ハザードマップURL)          :text(65535)
#  volcano(火山ハザードマップURL)          :text(65535)
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  city_id(市町村ID)                       :bigint           not null
#
# Indexes
#
#  index_hazard_maps_on_city_id  (city_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#
require 'rails_helper'

RSpec.describe HazardMap, type: :model do
  describe "correct_hazard_map" do
    let(:city) { create(:city) }
    let(:hazard_map) { build(:hazard_map, city: city) }

    it "ハザードマップが正しく作成されていること" do
      expect(hazard_map).to be_valid
    end
  end

  describe "validate presence" do
    context "cityがNULLの時" do
      let(:hazard_map) { build(:hazard_map, city: nil) }
      it "エラーメッセージが返る" do
        hazard_map.valid?
        expect(hazard_map).to be_invalid
      end
    end
  end

  describe "association" do
    it "Cityテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:city)
      expect(rel.macro).to eq :belongs_to
    end
  end
end
