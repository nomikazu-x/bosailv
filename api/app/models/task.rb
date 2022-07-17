# == Schema Information
#
# Table name: tasks
#
#  id              :bigint           not null, primary key
#  body(本文)      :text(4294967295) not null
#  summary(概要)   :string(50)       not null
#  title(タイトル) :string(30)       not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Task < ApplicationRecord
  mount_uploader :image, ImageUploader

  validates :image, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :summary, presence: true, length: { maximum: 50 }
  validates :body, presence: true
end
