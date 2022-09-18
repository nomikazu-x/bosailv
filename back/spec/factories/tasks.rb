# == Schema Information
#
# Table name: tasks
#
#  id              :bigint           not null, primary key
#  body(本文)      :text(4294967295) not null
#  summary(概要)   :string(50)       not null
#  title(タイトル) :string(30)       not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :task do
    title { Faker::Lorem.characters(number: 20) }
    image { File.new("#{Rails.root}/spec/fixtures/test_image.jpg") }
    summary { Faker::Lorem.characters(number: 30) }
    body { Faker::Lorem.characters(number: 50) }
    icon { "#{title}のアイコン" }
  end
end
