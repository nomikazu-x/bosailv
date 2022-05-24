class Infomation < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :action_user, class_name: 'User', optional: true
  belongs_to :article, optional: true

  enum label: { Not: 0, Maintenance: 1, Hindrance: 2, Other: 999 }
  enum target: { All: 1, User: 2 }

  default_scope { order(started_at: :desc, id: :desc) }
  scope :by_target, lambda { |current_user|
    where('target = ? OR (target = ? AND user_id = ?)', targets[:All], targets[:User], current_user&.id)
      .where('started_at <= ? AND (ended_at IS NULL OR ended_at >= ?)', Time.current, Time.current)
  }
  scope :by_force, -> { where('force_started_at <= ? AND (force_ended_at IS NULL OR force_ended_at >= ?)', Time.current, Time.current) }
  scope :by_unread, lambda { |infomation_check_last_started_at|
    where('started_at > ?', infomation_check_last_started_at) if infomation_check_last_started_at.present?
  }

  # 対象ユーザーかを返却
  def target_user?(current_user)
    target.to_sym == :All || (target.to_sym == :User && user_id == current_user&.id)
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
