class Api::V1::UsersController < Api::V1::ApplicationController
  def ranking
    @users = User.point_ranking.page(params[:page]).per(Settings['default_users_limit'])
    render './api/v1/users/ranking'
  end

  def show
    @user = User.find_by(username: params[:username])
    @articles = @user.articles.page(params[:page]).per(Settings['default_articles_limit'])
    @favorite_articles = @user.favorited_articles.page(params[:page]).per(Settings['default_articles_limit'])

    if @user
      render './api/v1/users/show'
    else
      head :not_found
    end
  end

  def genre_articles
    @user = User.find_by(username: params[:username])
    @genre = Genre.find(params[:id])
    @articles = @user.articles.page(params[:page]).per(Settings['default_articles_limit']).joins(:article_genre_relations).where("genre_id = #{@genre.id}")
    @favorite_articles = @user.favorited_articles.page(params[:page]).per(Settings['default_articles_limit']).joins(:article_genre_relations).where("genre_id = #{@genre.id}")
  
    if @user
      render './api/v1/users/genre_articles'
    else
      head :not_found
    end
  end
end
