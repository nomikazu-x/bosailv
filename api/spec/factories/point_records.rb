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
FactoryBot.define do
  factory :point_record do
    association :user
    obtained_point { Settings['article_create_obtained_point'] }
  end
end
