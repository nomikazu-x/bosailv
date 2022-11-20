class Api::V1::ArticlesController < Api::V1::ApplicationController
  before_action :authenticate_user!, except: %i[index show search]
  before_action :set_article, except: %i[create index search]
  before_action :correct_user?, only: %i[update destroy]

  # GET /api/v1/articles(.json) 記事一覧API
  def index
    if params[:famous]
      @articles = Article.all.ranking.page(params[:page]).per(Settings['default_articles_limit'])
    else
      @articles = Article.all.page(params[:page]).per(Settings['default_articles_limit'])
    end
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

  # GET /api/v1/articles/search(.json) 記事検索API(処理)
  def search
    # キーワードが存在する場合
    if params[:keyword].present?
      # キーワード検索
      @articles = Article.where('title Like ? OR content Like ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%").page(params[:page]).per(Settings['default_articles_limit'])

      # キーワードが選択されており、かつジャンルが選択されている場合
      if params[:genre_ids].present?
        # ジャンルを繰り返し処理して、選択されたすべてのジャンルと関連する記事一覧を取得
        params[:genre_ids].each do |genre_id|
          genre = Genre.find(genre_id)
          @articles = @articles.joins(:article_genre_relations).where("genre_id = #{genre.id}")
        end
        # 該当する記事を返す
        @articles = @articles.page(params[:page]).per(Settings['default_articles_limit'])
      end

    # キーワードが存在せず、ジャンルが選択されている場合
    elsif params[:genre_ids].present?
      # ジャンルを繰り返し処理して、選択されたすべてのジャンルと関連する記事一覧を取得
      params[:genre_ids].each do |genre_id|
        genre = Genre.find(genre_id)
        @articles = Article.all.joins(:article_genre_relations).where("genre_id = #{genre.id}")
      end
      # 該当する記事を返す
      @articles = @articles.page(params[:page]).per(Settings['default_articles_limit'])

    # キーワードもジャンルも選択されていない場合、すべての記事を返す
    else
      @articles = Article.all.page(params[:page]).per(Settings['default_articles_limit'])
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
