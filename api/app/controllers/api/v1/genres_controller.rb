class Api::V1::GenresController < Api::V1::ApplicationController
  def show
    genre = Genre.find(params[:id])
    @articles = genre.articles.page(params[:page]).per(Settings['default_articles_limit'])
    render './api/v1/genres/show'
  end
end
