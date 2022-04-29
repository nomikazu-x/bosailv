class Article < ApplicationRecord
  belongs_to :user

  has_many :favorites, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
end
