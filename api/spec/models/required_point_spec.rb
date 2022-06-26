# == Schema Information
#
# Table name: required_points
#
#  id                                    :bigint           not null, primary key
#  level(レベル)                         :integer          not null
#  lifelong_point(合計獲得ポイント)      :integer          not null
#  point(次のレベルまでに必要なポイント) :integer          not null
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#
require 'rails_helper'

RSpec.describe RequiredPoint, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
