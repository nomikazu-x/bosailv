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
  has_many :task_completes, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :image, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :summary, presence: true, length: { maximum: 50 }
  validates :body, presence: true
  validates :icon, presence: true

  # 画像URLを返却
  def image_url(version)
    case version
    when :large
      image? ? image.large.url : "/images/task/#{version}_noimage.jpeg"
    when :xlarge
      image? ? image.xlarge.url : "/images/task/#{version}_noimage.jpeg"
    when :xxlarge
      image? ? image.xxlarge.url : "/images/task/#{version}_noimage.jpeg"
    else
      logger.warn("[WARN]Not found: Task.image_url(#{version})")
      ''
    end
  end
end
