# == Schema Information
#
# Table name: genres
#
#  id               :bigint           not null, primary key
#  image(画像)      :text(65535)      not null
#  name(ジャンル名) :string(10)       not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :genre do
    
  end
end
