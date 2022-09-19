class Api::V1::GenresController < Api::V1::ApplicationController

  # GET /api/v1/genres(.json) ジャンル一覧API
  def index
    @genres = Genre.all.preload(:articles)
    render './api/v1/genres/index'
  end

  # GET /api/v1/genres/:id(.json) ジャンル詳細API
  def show
    @genre = Genre.find(params[:id])
    if params[:famous]
      # いいね数の多い順に取得
      @articles = @genre.articles.ranking.page(params[:page]).per(Settings['default_articles_limit'])
    else
      # 降順に取得
      @articles = @genre.articles.page(params[:page]).per(Settings['default_articles_limit'])
    end
    render './api/v1/genres/show'
  end
end
