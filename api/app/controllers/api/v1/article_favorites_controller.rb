class Api::V1::ArticleFavoritesController < Api::V1::ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  # POST /api/v1/articles/:id/article_favorites/create(.json) 記事お気にいりAPI(処理)
  def create
    article = Article.find(params[:id])

    if article
      ActiveRecord::Base.transaction do
        current_user.article_favorite!(article)
        # 記事作成者がポイント獲得
        author_point_record = PointRecorder.new(article.user).record(Settings['article_favorite_author_obtained_point'])
        author_required_point = RequiredPoint.find_by(level: article.user.level)
        # 読者もポイント獲得
        reader_point_record = PointRecorder.new(current_user).record(Settings['article_favorite_reader_obtained_point'])
        @reader_required_point = RequiredPoint.find_by(level: current_user.level)
        # 通知作成
        Infomation.new(started_at: Time.current, target: :User, user_id: article.user.id,
                      action: 'ArticleFavorite', action_user_id: current_user.id, article_id: article.id).save!
        
        render './api/v1/article_favorites/success', { notice: I18n.t('notice.article_favorite.create') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article_favorite.create') }, status: :unprocessable_entity
    end

  end

  # POST /api/v1/articles/:id/article_favorites/delete(.json) 記事お気にいり削除API(処理)
  def destroy
    article = Article.find(params[:id])

    if article
      ActiveRecord::Base.transaction do
        p current_user.article_favorites
        current_user.article_unfavorite!(article)
        # 記事作成者のポイントを減らす
        author_point_record = PointRecorder.new(article.user).delete_record(Settings['article_favorite_author_obtained_point'])
        author_required_point = RequiredPoint.find_by(level: article.user.level)
        # 読者のポイントを減らす
        reader_point_record = PointRecorder.new(current_user).delete_record(Settings['article_favorite_reader_obtained_point'])
        reader_required_point = RequiredPoint.find_by(level: current_user.level)

        render './api/v1/article_favorites/success', { notice: I18n.t('notice.article_favorite.destroy') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article_favorite.destroy') }, status: :unprocessable_entity
    end
  end
end
