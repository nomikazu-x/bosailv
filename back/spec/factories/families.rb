# == Schema Information
#
# Table name: families
#
#  id                  :bigint           not null, primary key
#  age(年代)           :integer          default(0), not null
#  sex(性別)           :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id(ユーザーID) :bigint           not null
#
# Indexes
#
#  index_families_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :family do
    association :user
    sex { 'male' }
    age { 'infant' }
  end
end
