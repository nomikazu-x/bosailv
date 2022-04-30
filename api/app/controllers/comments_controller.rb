class CommentsController < ApiController
  before_action :authenticate_user!, except: %i[index]

  def index
    article = Article.find(params[:article_id])
    @comments = article.comments
  end

  def create
    article = Article.find(params[:article_id])
    @comment = article.comments.build(comment_params)
    if @comment.save
      render './comments/success', locals: { notice: I18n.t('notice.comment.create') }
    else
      render './failure', locals: { alert: I18n.t('alert.comment.create') }, status: :unprocessable_entity
    end
  end

  def destroy
    article = Article.find(params[:article_id])
    @comment = article.comments.find(params[:id])
    return if current_user == @comment.user

    render './failure', locals: { alert: I18n.t('errors.messages.not_permission') }, status: :unauthorized
    if @comment.destroy
      render './comments/success', locals: { notice: I18n.t('notice.comment.destroy') }
    else
      render './failure', locals: { alert: I18n.t('alert.comment.destroy') }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
