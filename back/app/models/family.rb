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
class Family < ApplicationRecord
  belongs_to :user

  enum sex: { male: 1, female: 2 }, _prefix: true
  enum age: { infant: 1, child: 2, junior: 3, adult: 4, senior: 5 }, _prefix: true

  validates :sex, presence: true
  validates :age, presence: true
end
