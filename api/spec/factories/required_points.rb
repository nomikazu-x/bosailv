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
FactoryBot.define do
  factory :required_point do
    level { 1 }
    lifelong_point { 5 }
    point { 5 }
  end
end
