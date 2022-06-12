class Prefecture < ApplicationRecord
  has_many :cities

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
