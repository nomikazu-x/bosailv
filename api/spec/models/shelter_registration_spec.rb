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
require 'rails_helper'

RSpec.describe ShelterRegistration, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
