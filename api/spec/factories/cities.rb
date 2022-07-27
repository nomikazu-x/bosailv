# == Schema Information
#
# Table name: cities
#
#  city_code(市町村コード)   :bigint           not null, primary key
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
FactoryBot.define do
  factory :city do
    city_code { 1111 }
    name { Faker::Lorem.characters(number: 10) }
    association :prefecture
  end
end
