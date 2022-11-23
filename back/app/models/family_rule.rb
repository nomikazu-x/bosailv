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
class FamilyRule < ApplicationRecord
  belongs_to :user

  validates :contact_means_memo, presence: true
  validates :contact_means_memo, length: { maximum: Settings['family_rule_contact_means_memo_maximum'] }
  validates :emergency_measure_memo, presence: true
  validates :emergency_measure_memo, length: { maximum: Settings['family_rule_emergency_measure_memo_maximum'] }
  validates :family_role_memo, presence: true
  validates :family_role_memo, length: { maximum: Settings['family_rule_family_role_memo_maximum'] }
  validates :leave_home_memo, presence: true
  validates :leave_home_memo, length: { maximum: Settings['family_rule_leave_home_memo_maximum'] }
  validates :refuge_memo, presence: true
  validates :refuge_memo, length: { maximum: Settings['family_rule_refuge_memo_maximum'] }
end
