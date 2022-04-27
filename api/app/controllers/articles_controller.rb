class ArticlesController < ApiController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_article, except: %i[new create index]
  before_action :correct_user?, only: %i[update destroy]

  def index
    @articles = Article.all.page(params[:page]).per(Settings['default_infomations_limit'])
  end

  def create
    @article = current_user.articles.build(article_params)
    if @ariticle.save
      render './articles/success', locals: { notice: I18n.t('notice.article.create') }
    else
      render './failure', locals: { alert: I18n.t('alert.article.create') }, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      render './articles/success', locals: { notice: I18n.t('notice.article.update') }
    else
      render './failure', locals: { alert: I18n.t('alert.article.update') }, status: :unprocessable_entity
    end
  end

  def destroy
    if @article.destroy
      render './articles/success', locals: { notice: I18n.t('notice.article.destroy') }
    else
      render './failure', locals: { alert: I18n.t('alert.article.destroy') }, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :user_id)
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def correct_user?
    return if current_user == @article.user

    render './failure', locals: { alert: I18n.t('errors.messages.not_permission') }, status: :unauthorized
  end
end
