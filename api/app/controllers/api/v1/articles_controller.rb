class Api::V1::ArticlesController < Api::V1::ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_article, except: %i[create index search category]
  before_action :correct_user?, only: %i[update destroy]

  def index
    @articles = Article.all.page(params[:page]).per(Settings['default_articles_limit'])
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      render './api/v1/articles/success', locals: { notice: I18n.t('notice.article.create') }
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
      render './api/v1/articles/success', locals: { notice: I18n.t('notice.article.destroy') }
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

  def category
    if params[:selected_categories].present?
      params[:selected_categories].each do |selected_category| 
        @articles = Article.where_all_category(selected_category).page(params[:page]).per(Settings['default_articles_limit'])
      end
    else
      @articles = Article.all.page(params[:page]).per(Settings['default_articles_limit'])
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :user_id, category: [])
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def correct_user?
    return if current_user == @article.user

    render './api/v1/failure', locals: { alert: I18n.t('errors.messages.not_permission') }, status: :unauthorized
  end
end
