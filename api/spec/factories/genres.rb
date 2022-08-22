# == Schema Information
#
# Table name: genres
#
#  id                  :bigint           not null, primary key
#  description(説明文) :text(65535)      not null
#  image(画像)         :text(65535)      not null
#  name(ジャンル名)    :string(10)       not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :genre do
    name { Faker::Lorem.characters(number: 5) }
    image { File.new("#{Rails.root}/spec/fixtures/test_image.jpg") }
    description { "#{name}の説明文" }
  end
end
