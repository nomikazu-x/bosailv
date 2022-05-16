class Api::V1::ArticleFavoritesController < Api::V1::ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    article = Article.find(params[:article_id])
    current_user.article_favorite!(article)

    render json: { notice: I18n.t('notice.article_favorite.create') }
  end

  def destroy
    article = Article.find(params[:article_id])
    current_user.article_unfavorite!(article)

    render json: { notice: I18n.t('notice.article_favorite.destroy') }
  end
end
