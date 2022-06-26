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
class RequiredPoint < ApplicationRecord
  validates :level, presence: true
  validates :lifelong_point, presence: true
  validates :point, presence: true
end
