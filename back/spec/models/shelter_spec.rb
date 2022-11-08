# == Schema Information
#
# Table name: shelters
#
#  id                            :bigint           not null, primary key
#  address(住所)                 :string(255)      not null
#  city_name(市町村名)           :string(255)      not null
#  duplicate(指定避難所との重複) :boolean          default(FALSE), not null
#  earthquake(地震)              :boolean          default(FALSE), not null
#  fire(火事)                    :boolean          default(FALSE), not null
#  flood(洪水)                   :boolean          default(FALSE), not null
#  inland_flood(内水氾濫)        :boolean          default(FALSE), not null
#  landslide(土砂)               :boolean          default(FALSE), not null
#  latitude(緯度)                :decimal(14, 12)  not null
#  longitude(経度)               :decimal(14, 12)  not null
#  name(施設・場所名)            :string(255)      not null
#  remark(備考)                  :string(255)
#  storm_surge(高潮)             :boolean          default(FALSE), not null
#  tsunami(津波)                 :boolean          default(FALSE), not null
#  volcano(火山)                 :boolean          default(FALSE), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  city_id(市町村ID)             :bigint           not null
#
# Indexes
#
#  index_shelters_on_city_id  (city_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#
require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe "correct_shelter" do
    let(:city) { create(:city) }
    let(:shelter) { build(:shelter, city: city) }

    it "避難所が正しく作成されていること" do
      expect(shelter).to be_valid
    end
  end

  describe "validate presence" do
    context "addressがNULLの時" do
      let(:shelter) { build(:shelter, address: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "city_nameがNULLの時" do
      let(:shelter) { build(:shelter, city_name: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "duplicateがNULLの時" do
      let(:shelter) { build(:shelter, duplicate: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "earthquakeがNULLの時" do
      let(:shelter) { build(:shelter, earthquake: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "fireがNULLの時" do
      let(:shelter) { build(:shelter, fire: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "floodがNULLの時" do
      let(:shelter) { build(:shelter, flood: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "inland_floodがNULLの時" do
      let(:shelter) { build(:shelter, inland_flood: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "landslideがNULLの時" do
      let(:shelter) { build(:shelter, landslide: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "latitudeがNULLの時" do
      let(:shelter) { build(:shelter, latitude: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "longitudeがNULLの時" do
      let(:shelter) { build(:shelter, longitude: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "nameがNULLの時" do
      let(:shelter) { build(:shelter, name: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "storm_surgeがNULLの時" do
      let(:shelter) { build(:shelter, storm_surge: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "tsunamiがNULLの時" do
      let(:shelter) { build(:shelter, tsunami: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "volcanoがNULLの時" do
      let(:shelter) { build(:shelter, volcano: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
      end
    end

    context "cityがNULLの時" do
      let(:shelter) { build(:shelter, city: nil) }
      it "エラーメッセージが返る" do
        shelter.valid?
        expect(shelter).to be_invalid
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
