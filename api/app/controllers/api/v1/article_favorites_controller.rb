class Api::V1::ArticleFavoritesController < Api::V1::ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    article = Article.find(params[:article_id])

    ActiveRecord::Base.transaction do
      if current_user.article_favorite!(article)
        Infomation.new(started_at: Time.current, target: :User, user_id: article.user.id,
                      action: 'ArticleFavorite', action_user_id: current_user.id, article_id: article.id).save!
      else
        render './api/v1/failure', locals: { alert: I18n.t('alert.article_favorite.create') }, status: :unprocessable_entity
      end
    end

    render json: { notice: I18n.t('notice.article_favorite.create') }
  end

  def destroy
    article = Article.find(params[:article_id])
    ActiveRecord::Base.transaction do
      if current_user.article_unfavorite!(article)
        render json: { notice: I18n.t('notice.article_favorite.destroy') }
      else
        render './api/v1/failure', locals: { alert: I18n.t('alert.article_favorite.destroy') }, status: :unprocessable_entity
      end
    end
  end
end
