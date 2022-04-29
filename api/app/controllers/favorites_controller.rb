class FavoritesController < ApiController
  before_action :authenticate_user!

  def create
    favorite = current_user.favorites.create!(post_id: favorite_params[:article_id])
    render json: favorite, locals: { notice: I18n.t('notice.favorite.create') }
  end

  def destroy
    favorite = Favorite.find_by(article_id: params[:id], user_id: current_user.id)
    if favorite.destroy!
      render json: favorite, locals: { notice: I18n.t('notice.favorite.destroy') }
    else
      render './failure', locals: { alert: I18n.t('alert.favorite.destroy') }, status: :unprocessable_entity
    end
  end

  private

  def favorite_params
    params.require(:favorite).permit(:user_id, :article_id)
  end
end
