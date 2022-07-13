class Api::V1::GenresController < Api::V1::ApplicationController
  before_action :redirect_not_admin, only: %i[create destroy]

  # GET /api/v1/genres(.json) ジャンル一覧API
  def index
    @genres = Genre.all
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

  # POST /api/v1/genres/create(.json) ジャンル作成API
  def create
    genre = Genre.new(genre_params)

    if genre.save
      render './api/v1/success', locals: { notice: I18n.t('notice.genre.create') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.genre.create') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/genres/:id/update(.json) 記事更新API(処理)
  def update
    genre = Genre.find(params[:id])

    if genre.update(genre_params)
      render './api/v1/success', locals: { notice: I18n.t('notice.genre.update') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.genre.update') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/genres/:id/delete(.json) ジャンル削除API
  def destroy
    genre = Genre.find(params[:id])

    if genre.destroy
      render './api/v1/success', locals: { notice: I18n.t('notice.genre.destroy') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.genre.destroy') }, status: :unprocessable_entity
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:name, :image)
  end

  def redirect_not_admin
    return if current_user.admin?

    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.not_permission') }, status: :unauthorized
  end
end
