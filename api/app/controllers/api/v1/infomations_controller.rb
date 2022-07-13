class Api::V1::InfomationsController < Api::V1::ApplicationController
  before_action :redirect_not_admin, only: %i[create destroy]

  # GET /api/v1/infomations(.json) お知らせ一覧API
  def index
    @infomations = Infomation.by_target(current_user).page(params[:page]).per(Settings['default_infomations_limit'])
    update_infomation_check
  end

  # GET /api/v1/infomations/important(.json) 大切なお知らせAPI
  def important
    @infomations = Infomation.by_target(current_user).by_force
  end

  # GET /api/v1/infomations/:id(.json) お知らせ詳細API
  def show
    @infomation = Infomation.find(params[:id])
    return head :not_found if @infomation.blank? || !@infomation.target_user?(current_user) || @infomation.started_at > Time.current

    if @infomation.ended_at.present? && @infomation.ended_at < Time.current
      render './api/v1/failure', locals: { alert: I18n.t('errors.messages.infomation.ended') }, status: :not_found
    end
  end

  # POST /api/v1/infomations/create(.json) お知らせ作成API
  def create
    infomation = Infomation.new(infomation_params)

    if infomation.save
      render './api/v1/success', locals: { notice: I18n.t('notice.infomation.create') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.infomation.create') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/infomations/:id/delete(.json) お知らせ削除API
  def destroy
    infomation = Infomation.find(params[:id])

    if infomation.destroy
      render './api/v1/success', locals: { notice: I18n.t('notice.infomation.destroy') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.infomation.destroy') }, status: :unprocessable_entity
    end
  end

  private

  # お知らせ確認情報更新
  def update_infomation_check
    return if current_user.blank? || @infomations.blank? || @infomations.current_page != 1

    current_user.infomation_check_last_started_at = @infomations.first.started_at
    current_user.save!
  end

  def infomation_params
    params.require(:infomation).permit(:label, :title, :summary, :body, :started_at, :ended_at, :force_started_at, :force_ended_at, :target, :user_id)
  end
end
