# == Schema Information
#
# Table name: hazard_maps
#
#  id                                      :bigint           not null, primary key
#  code(市町村コード)                      :string(255)      not null
#  flood(洪水ハザードマップURL)            :string(255)
#  inland_flood(内水氾濫ハザードマップURL) :string(255)
#  landslide(土砂災害ハザードマップURL)    :string(255)
#  reservoir(ため池ハザードマップURL)      :string(255)
#  storm_surge(高潮ハザードマップURL)      :string(255)
#  tsunami(津波ハザードマップURL)          :string(255)
#  volcano(火山ハザードマップURL)          :string(255)
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#
require 'rails_helper'

RSpec.describe HazardMap, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
