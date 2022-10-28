# == Schema Information
#
# Table name: family_rules
#
#  id                                     :bigint           not null, primary key
#  contact_means_memo(緊急時連絡手段メモ) :text(65535)      not null
#  emergency_measure_memo(応急処置メモ)   :text(65535)      not null
#  family_role_memo(家族の役割分担メモ)   :text(65535)      not null
#  leave_home_memo(家を離れるときメモ)    :text(65535)      not null
#  refuge_memo(避難方法メモ)              :text(65535)      not null
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  user_id(ユーザーID)                    :bigint           not null
#
# Indexes
#
#  index_family_rules_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :family_rule do
    association :user
    contact_means_memo { Faker::Lorem.characters(number: 10) }
    emergency_measure_memo { Faker::Lorem.characters(number: 10) }
    family_role_memo { Faker::Lorem.characters(number: 10) }
    leave_home_memo { Faker::Lorem.characters(number: 10) }
    refuge_memo { Faker::Lorem.characters(number: 10) }
  end
end
