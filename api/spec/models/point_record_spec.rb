# == Schema Information
#
# Table name: point_records
#
#  id                         :bigint           not null, primary key
#  obtained_point(獲得経験値) :integer          not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  user_id(ユーザーID)        :bigint           not null
#
# Indexes
#
#  index_point_records_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe PointRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
