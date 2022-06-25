class Api::V1::UsersController < Api::V1::ApplicationController
  def index
    @users = User.point_ranking.page(params[:page]).per(Settings['default_users_limit'])
    render './api/v1/users/index'
  end

  def show
    @user = User.find_by(username: params[:username])
    @required_point = RequiredPoint.find_by(level: @user.level).required_point
    @prefecture = Prefecture.find(@user.prefecture_id).name if @user.prefecture_id.present?
    @city = City.find(@user.city_id).name if @user.prefecture_id.present?

    if @user
      render './api/v1/users/show'
    else
      head :not_found
    end
  end

  def genre_articles
    @user = User.find_by(username: params[:username])
    @genre = Genre.find(params[:id])
    if params[:favorite]
      @articles = @user.favorited_articles.page(params[:page]).per(Settings['default_articles_limit']).joins(:article_genre_relations).where("genre_id = #{@genre.id}")
    else
      @articles = @user.articles.page(params[:page]).per(Settings['default_articles_limit']).joins(:article_genre_relations).where("genre_id = #{@genre.id}")
    end
    
    if @user
      render './api/v1/users/genre_articles'
    else
      head :not_found
    end
  end
end
