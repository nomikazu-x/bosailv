class InfomationsController < ApiController
  def index
    @infomations = Infomation.order(started_at: 'DESC', id: 'DESC').page(params[:page]).per(25)
                             .where('started_at <= ? AND (ended_at IS NULL OR ended_at >= ?)', Time.current, Time.current)
                             .where('target = ? OR (target = ? AND user_id = ?)', Infomation.targets[:All], Infomation.targets[:User], current_user&.id)
  end

  def show
    @infomation = Infomation.find(params[:id])
    if @infomation.ended_at.present? && @infomation.ended_at < Time.current
      render './failure', locals: { alert: I18n.t('errors.messages.infomation.ended') }, status: :not_found
    end
  end
end
