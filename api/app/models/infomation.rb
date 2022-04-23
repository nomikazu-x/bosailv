class Infomation < ApplicationRecord
  belongs_to :user, optional: true

  enum label: { Not: 0, Maintenance: 1, Hindrance: 2, Other: 99 }
  enum target: { All: 1, User: 2 }

  default_scope { order(started_at: :desc, id: :desc) }
  scope :by_target, lambda { |current_user|
    where('target = ? OR (target = ? AND user_id = ?)', targets[:All], targets[:User], current_user&.id)
      .where('started_at <= ? AND (ended_at IS NULL OR ended_at >= ?)', Time.current, Time.current)
  }
  scope :by_force, -> { where('force_started_at <= ? AND (force_ended_at IS NULL OR force_ended_at >= ?)', Time.current, Time.current) }
end
