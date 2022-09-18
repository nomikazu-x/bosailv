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
  pending "add some examples to (or delete) #{__FILE__}"
end
