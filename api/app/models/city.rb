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
class City < ApplicationRecord
  belongs_to :prefecture

  has_one :hazard_map, primary_key: :city_code

  validates :city_code, presence: true
  validates :name, presence: true
  validates :prefecture_id, presence: true
end
