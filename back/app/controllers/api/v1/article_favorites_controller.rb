class Api::V1::ArticleFavoritesController < Api::V1::ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_article, only: %i[create destroy]
  before_action :not_correct_user?, only: %i[create destroy]

  # POST /api/v1/articles/:id/article_favorites/create(.json) 記事お気にいりAPI(処理)
  def create
    if current_user.article_favorite!(@article)
      ActiveRecord::Base.transaction do
        # 記事作成者がポイント獲得
        PointRecorder.new(@article.user).record(Settings['article_favorite_author_obtained_point'])
        # 読者もポイント獲得
        PointRecorder.new(current_user).record(Settings['article_favorite_reader_obtained_point'])
        # 通知作成
        Infomation.new(started_at: Time.current, target: :user, user_id: @article.user.id,
                       action: 'ArticleFavorite', action_user_id: current_user.id, article_id: @article.id).save!

        render './api/v1/auth/success', locals: { notice: I18n.t('notice.article_favorite.create') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article_favorite.create') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/articles/:id/article_favorites/delete(.json) 記事お気にいり削除API(処理)
  def destroy
    if current_user.article_unfavorite!(@article)
      ActiveRecord::Base.transaction do
        # 記事作成者のポイントを減らす
        PointRecorder.new(@article.user).delete_record(Settings['article_favorite_author_obtained_point'])
        # 読者のポイントを減らす
        PointRecorder.new(current_user).delete_record(Settings['article_favorite_reader_obtained_point'])

        render './api/v1/auth/success', locals: { notice: I18n.t('notice.article_favorite.destroy') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article_favorite.destroy') }, status: :unprocessable_entity
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def not_correct_user?
    return if current_user != @article.user

    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.not_correct_user') }, status: :unauthorized
  end
end
