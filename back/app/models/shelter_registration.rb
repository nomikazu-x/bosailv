# == Schema Information
#
# Table name: shelter_registrations
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  shelter_id(避難所ID) :bigint           not null
#  user_id(ユーザーID)  :bigint           not null
#
# Indexes
#
#  index_shelter_registrations_on_shelter_id              (shelter_id)
#  index_shelter_registrations_on_user_id                 (user_id)
#  index_shelter_registrations_on_user_id_and_shelter_id  (user_id,shelter_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (shelter_id => shelters.id)
#  fk_rails_...  (user_id => users.id)
#
class ShelterRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :shelter

  validates :user_id, presence: true
  validates :shelter_id, presence: true
end
