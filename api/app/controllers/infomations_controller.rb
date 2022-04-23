class InfomationsController < ApiController
  def index
    @infomations = Infomation.by_target(current_user).page(params[:page]).per(25)
  end

  def important
    @infomations = Infomation.by_target(current_user).by_force
  end

  def show
    @infomation = Infomation.find(params[:id])
    if @infomation.ended_at.present? && @infomation.ended_at < Time.current
      render './failure', locals: { alert: I18n.t('errors.messages.infomation.ended') }, status: :not_found
    end
  end
end
