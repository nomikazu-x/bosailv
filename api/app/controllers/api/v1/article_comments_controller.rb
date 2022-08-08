class Api::V1::ArticleCommentsController < Api::V1::ApplicationController
  before_action :authenticate_user!, except: %i[index]

  def index
    @article_comments = Article.find(params[:id]).article_comments.eager_load(:user)
  end

  # POST /api/v1/article_comments/create(.json) 記事コメント作成API(処理)
  def create
    @article_comment = current_user.article_comments.build(article_comment_params)

    if @article_comment.save
      # 通知作成
      Infomation.new(started_at: Time.current, target: :User, user_id: @article_comment.article.user.id,
                     action: 'ArticleComment', action_user_id: current_user.id, article_id: @article_comment.article.id).save!

      render './api/v1/article_comments/success', locals: { notice: I18n.t('notice.article_comment.create') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article_comment.create') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/article_comments/:id/delete(.json) 記事コメント削除API(処理)
  def destroy
    article_comment = current_user.article_comments.find(params[:id])

    if article_comment.destroy
      render './api/v1/article_comments/success', locals: { notice: I18n.t('notice.article_comment.destroy') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.article_comment.destroy') }, status: :unprocessable_entity
    end
  end

  private

  def article_comment_params
    params.require(:article_comment).permit(:content, :user_id, :article_id)
  end
end
