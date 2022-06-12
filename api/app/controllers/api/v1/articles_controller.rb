class Api::V1::ArticlesController < Api::V1::ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_article, except: %i[create index search]
  before_action :correct_user?, only: %i[update destroy]

  def index
    @articles = Article.all.page(params[:page]).per(Settings['default_articles_limit'])
  end

  def create
    @article = current_user.articles.build(article_params)
    
    if @article.save
      ActiveRecord::Base.transaction do
        point_record = PointRecorder.new(@article.user).record(Settings['article_create_obtained_point'])
        required_point = RequiredPoint.find_by(level: @article.user.level)
        render './api/v1/articles/success', locals: { notice: I18n.t('notice.article.create') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article.create') }, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      render './api/v1/articles/success', locals: { notice: I18n.t('notice.article.update') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article.update') }, status: :unprocessable_entity
    end
  end

  def destroy
    if @article.destroy
      ActiveRecord::Base.transaction do
        point_record = PointRecorder.new(@article.user).delete_record(Settings['article_create_obtained_point'])
        required_point = RequiredPoint.find_by(level: @article.user.level)
        render './api/v1/articles/success', locals: { notice: I18n.t('notice.article.destroy') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article.destroy') }, status: :unprocessable_entity
    end
  end

  def search
    if params[:keyword].present?
      @articles = Article.where('title Like ? OR content Like ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%").page(params[:page]).per(Settings['default_articles_limit'])
    else
      @articles = Article.all.page(params[:page]).per(Settings['default_articles_limit'])
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :user_id, :thumbnail, genre_ids: [])
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def correct_user?
    return if current_user == @article.user

    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.not_permission') }, status: :unauthorized
  end
end
