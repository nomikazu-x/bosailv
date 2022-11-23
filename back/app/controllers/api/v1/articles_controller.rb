class Api::V1::ArticlesController < Api::V1::ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_article, except: %i[create index]
  before_action :correct_user?, only: %i[update destroy]

  # GET /api/v1/articles(.json) 記事一覧API
  def index
    keyword = params[:keyword]&.slice(..(255 - 1))

    @articles = Article.by_favorite_count_ranking(params[:famous]) # Tips: famousがtrueの場合、お気に入り数ランキング順で取得
                       .search_keyword(keyword) # Tips: keywordがある場合、ワード検索
                       .search_genre(params[:genre_ids]) # Tips: genre_idがある場合、合致するジャンルで検索
                       .page(params[:page]).per(Settings['default_articles_limit'])
  end

  # GET /api/v1/articles/:id(.json) 記事詳細API
  # def show

  # end

  # POST /api/v1/articles/create(.json) 記事作成API(処理)
  def create
    @article = current_user.articles.build(article_params)

    if @article.save!
      ActiveRecord::Base.transaction do
        # ポイント獲得
        PointRecorder.new(current_user).record(Settings['article_create_obtained_point'])

        render './api/v1/articles/success', locals: { notice: I18n.t('notice.article.create') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article.create') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/articles/:id/update(.json) 記事更新API(処理)
  def update
    if @article.update(article_params)
      render './api/v1/articles/success', locals: { notice: I18n.t('notice.article.update') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article.update') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/articles/:id/delete(.json) 記事削除API(処理)
  def destroy
    if @article.destroy!
      ActiveRecord::Base.transaction do
        # ポイントを減らす
        PointRecorder.new(current_user).delete_record(Settings['article_create_obtained_point'])

        render './api/v1/articles/success', locals: { notice: I18n.t('notice.article.destroy') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article.destroy') }, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :thumbnail, genre_ids: [])
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def correct_user?
    return if current_user == @article.user

    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.not_permission') }, status: :unauthorized
  end
end
