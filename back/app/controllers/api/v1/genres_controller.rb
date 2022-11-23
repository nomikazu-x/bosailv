class Api::V1::GenresController < Api::V1::ApplicationController

  # GET /api/v1/genres(.json) ジャンル一覧API
  def index
    @genres = Genre.all.preload(:articles)
    render './api/v1/genres/index'
  end

  # GET /api/v1/genres/:id(.json) ジャンル詳細API
  def show
    @genre = Genre.find(params[:id])
    @user = User.find_by(username: params[:username])

    @articles = Article.by_favorite_count_ranking(params[:famous]) # Tips: famousがtrueの場合、お気に入り数ランキング順で取得
                       .by_target(@user, params[:favorite])        # Tips: usernameがある場合、favoriteの状況に応じて、執筆記事またはマイ記事を取得
                       .search_genre(params[:id])                  # Tips: genre_idで合致するジャンルで検索
                       .page(params[:page]).per(Settings['default_articles_limit'])
  end
end
