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
    sequence(:title) { |n| "task(#{n})" }
    image { File.new(TEST_IMAGE_FILE) }
    summary { "#{title}の要約" }
    body { "#{title}の本文" }
    icon { "#{title}のアイコン" }
  end
end
