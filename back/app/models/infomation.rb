# == Schema Information
#
# Table name: infomations
#
#  id                                   :bigint           not null, primary key
#  action(アクション)                   :string(255)
#  body(本文)                           :text(65535)
#  ended_at(終了日時)                   :datetime
#  force_ended_at(強制表示終了日時)     :datetime
#  force_started_at(強制表示開始日時)   :datetime
#  label(ラベル)                        :integer          default("Not"), not null
#  started_at(開始日時)                 :datetime         not null
#  summary(概要)                        :string(255)
#  target(対象)                         :integer          not null
#  title(タイトル)                      :string(255)      not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  action_user_id(アクションユーザーID) :bigint
#  article_id(記事ID)                   :bigint
#  user_id(ユーザーID)                  :bigint
#
# Indexes
#
#  index_infomations_on_article_id  (article_id)
#  index_infomations_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Infomation < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :action_user, class_name: 'User', optional: true
  belongs_to :article, optional: true

  enum label: { not: 0, maintenance: 1, hindrance: 2, other: 999 }, _prefix: true
  enum target: { all: 1, user: 2 }, _prefix: true

  default_scope { order(started_at: :desc, id: :desc) }
  scope :by_target, lambda { |current_user|
    where('target = ? OR (target = ? AND user_id = ?)', targets[:all], targets[:user], current_user&.id)
      .where('started_at <= ? AND (ended_at IS NULL OR ended_at >= ?)', Time.current, Time.current)
  }
  scope :by_force, -> { where('force_started_at <= ? AND (force_ended_at IS NULL OR force_ended_at >= ?)', Time.current, Time.current) }
  scope :by_unread, lambda { |infomation_check_last_started_at|
    where('started_at > ?', infomation_check_last_started_at) if infomation_check_last_started_at.present?
  }

  validates :started_at, presence: true
  validates :target, presence: true

  # 対象ユーザーかを返却
  def target_user?(current_user)
    target.to_sym == :all || (target.to_sym == :user && user_id == current_user&.id)
  end

  # アクションに応じたタイトルを返却
  def action_title
    case action
    when 'ArticleFavorite' # 記事にいいねされた
      get_title('infomation.action.article_favorite')
    when 'ArticleComment' # 記事にコメントされた
      get_title('infomation.action.article_comment')
    when nil
      title
    else
      logger.warn("[WARN]Not found: Infomation.action_title(#{action})")
      nil
    end
  end

  private

  # タイトルの動的要素を置き換えて返却
  def get_title(key)
    I18n.t(key)
        .gsub(/%{action_user_name}/, action_user.present? ? action_user.name : I18n.t('infomation.action_user.blank.name'))
        .gsub(/%{article_title}/, article.present? ? article.title : I18n.t('infomation.article.blank.name'))
  end
end
