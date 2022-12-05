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
FactoryBot.define do
  factory :hazard_map do
    sequence(:flood) { |n| "flood(#{n})" }
    sequence(:inland_flood) { |n| "inland_flood(#{n})" }
    sequence(:landslide) { |n| "landslide(#{n})" }
    sequence(:reservoir) { |n| "reservoir(#{n})" }
    sequence(:storm_surge) { |n| "storm_surge(#{n})" }
    sequence(:tsunami) { |n| "tsunami(#{n})" }
    sequence(:volcano) { |n| "volcano(#{n})" }
    association :city
  end
end
