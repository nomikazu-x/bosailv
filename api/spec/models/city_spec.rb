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
  pending "add some examples to (or delete) #{__FILE__}"
end
