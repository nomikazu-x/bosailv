# == Schema Information
#
# Table name: hazard_maps
#
#  id                                      :bigint           not null
#  city_code(市町村コード)                 :bigint           not null, primary key
#  flood(洪水ハザードマップURL)            :text(65535)
#  inland_flood(内水氾濫ハザードマップURL) :text(65535)
#  landslide(土砂災害ハザードマップURL)    :text(65535)
#  reservoir(ため池ハザードマップURL)      :text(65535)
#  storm_surge(高潮ハザードマップURL)      :text(65535)
#  tsunami(津波ハザードマップURL)          :text(65535)
#  volcano(火山ハザードマップURL)          :text(65535)
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#
# Indexes
#
#  fk_rails_9f2602e932  (city_code)
#
# Foreign Keys
#
#  fk_rails_...  (city_code => cities.city_code)
#
class HazardMap < ApplicationRecord
  self.primary_key = :city_code

  belongs_to :city

  validates :city_code, presence: true
end
