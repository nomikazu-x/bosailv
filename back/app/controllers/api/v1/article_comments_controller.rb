class Api::V1::ArticleCommentsController < Api::V1::ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :set_article, only: %i[index create destroy]

  # GET /api/v1/article_id/article_comments(.json) 記事コメント一覧API
  def index
    @article_comments = @article.article_comments.eager_load(:user)
  end

  # POST /api/v1/article_id/article_comments/create(.json) 記事コメント作成API(処理)
  def create
    @article_comment = current_user.article_comments.build(article_comment_params)

    if @article_comment.save
      # 通知作成
      Infomation.new(started_at: Time.current, target: :user, user_id: @article_comment.article.user.id,
                     action: 'ArticleComment', action_user_id: current_user.id, article_id: @article_comment.article.id).save!

      render './api/v1/article_comments/success', locals: { notice: I18n.t('notice.article_comment.create') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article_comment.create') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/article_id/article_comments/:id/delete(.json) 記事コメント削除API(処理)
  def destroy
    article_comment = current_user.article_comments.find_by!(article_id: @article.id)

    if article_comment.destroy
      render './api/v1/article_comments/success', locals: { notice: I18n.t('notice.article_comment.destroy') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article_comment.destroy') }, status: :unprocessable_entity
    end
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def article_comment_params
    params.require(:article_comment).permit(:content).merge(article_id: @article.id)
  end
end
