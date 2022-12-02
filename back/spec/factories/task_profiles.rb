# == Schema Information
#
# Table name: task_profiles
#
#  id                                              :bigint           not null, primary key
#  hazard_map_confirmed_at(ハザードマップ確認日時) :datetime
#  house_tasks(家庭関係防災タスク)                 :bigint           default(0), not null
#  sns_tasks(SNS関係防災タスク)                    :bigint           default(0), not null
#  stock_tasks(備蓄関係防災タスク)                 :bigint           default(0), not null
#  created_at                                      :datetime         not null
#  updated_at                                      :datetime         not null
#  user_id(ユーザーID)                             :bigint           not null
#
# Indexes
#
#  index_task_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :task_profile do
    house_tasks { 1 }
    sns_tasks { 1 }
    stock_tasks { 1 }
    association :user

    trait :hazard_map_confirmed do
      hazard_map_confirmed_at { Time.current }
    end
  end
end
