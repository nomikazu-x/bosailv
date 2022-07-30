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
class City < ApplicationRecord
  belongs_to :prefecture

  has_one :hazard_map, dependent: :destroy
  has_many :shelters, dependent: :destroy

  validates :name, presence: true
  validates :prefecture_id, presence: true
end
