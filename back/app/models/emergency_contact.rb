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
class EmergencyContact < ApplicationRecord
  belongs_to :user

  VALID_PHONE_NUMBER_REGEX = /\A0(\d{1}[-(]?\d{4}|\d{2}[-(]?\d{3}|\d{3}[-(]?\d{2}|\d{4}[-(]?\d{1})[-)]?\d{4}\z|\A0[5789]0[-]?\d{4}[-]?\d{4}\z/

  validates :name, presence: true
  validates :name, length: { maximum: Settings['emergency_contact_name_maximum'] }
  validates :phone_number, presence: true
  validates :phone_number, format: { with: VALID_PHONE_NUMBER_REGEX }
end
