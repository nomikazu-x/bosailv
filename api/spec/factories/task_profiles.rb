# == Schema Information
#
# Table name: task_profiles
#
#  id                                                :bigint           not null, primary key
#  house_tasks(家庭関係防災タスク)                   :integer          default(0), not null
#  is_completed_stock_task(備蓄防災タスク達成フラグ) :boolean          default(FALSE), not null
#  sns_tasks(SNS関係防災タスク)                      :integer          default(0), not null
#  created_at                                        :datetime         not null
#  updated_at                                        :datetime         not null
#  user_id(ユーザーID)                               :bigint           not null
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
    
  end
end
