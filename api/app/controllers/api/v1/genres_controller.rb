class Api::V1::GenresController < Api::V1::ApplicationController
  def index
    @genres = Genre.all
    render './api/v1/genres/index'
  end

  def show
    @genre = Genre.find(params[:id])
    if params[:famous]
      @articles = @genre.articles.ranking.page(params[:page]).per(Settings['default_articles_limit'])
    else
      @articles = @genre.articles.page(params[:page]).per(Settings['default_articles_limit'])
    end
    render './api/v1/genres/show'
  end
end
