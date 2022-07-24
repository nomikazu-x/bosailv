# == Schema Information
#
# Table name: emergency_contacts
#
#  id                     :bigint           not null, primary key
#  name(連絡先名)         :string(255)      not null
#  phone_number(電話番号) :string(255)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_id(ユーザーID)    :bigint           not null
#
# Indexes
#
#  index_emergency_contacts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :emergency_contact do
    
  end
end
