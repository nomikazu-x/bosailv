class FavoritesController < ApiController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    article = Article.find(params[:article_id])
    current_user.favorite!(article)

    render json: { notice: I18n.t('notice.favorite.create') }
  end

  def destroy
    article = Article.find(params[:article_id])
    current_user.unfavorite!(article)

    render json: { notice: I18n.t('notice.favorite.destroy') }
  end
end
