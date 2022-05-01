class CommentsController < ApiController
  before_action :authenticate_user!, except: %i[index]

  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      render './comments/success', locals: { notice: I18n.t('notice.comment.create') }
    else
      render './failure', locals: { alert: I18n.t('alert.comment.create') }, status: :unprocessable_entity
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])

    if comment.destroy
      render './comments/success', locals: { notice: I18n.t('notice.comment.destroy') }
    else
      render './failure', locals: { alert: I18n.t('alert.comment.destroy') }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :user_id, :article_id)
  end
end
