class Api::V1::SheltersController < Api::V1::ApplicationController

  # GET /api/v1/shelters(.json) 避難所一覧API
  def index
    if params[:prefecture_id].blank? || params[:city_id].blank?
      return render './api/v1/failure', locals: { alert: I18n.t('errors.messages.validate_params') }, status: :unprocessable_entity
    end

    @prefecture = Prefecture.find(params[:prefecture_id])
    @city = City.find(params[:city_id])
    user = User.find_by(username: params[:username])

    @shelters = Shelter.where(city: @city).by_target(user).page(params[:page]).per(Settings['default_shelters_limit'])
    @shelters = @shelters.where("#{params[:disaster_type]} = true") if params[:disaster_type]
  end

  # GET /api/v1/shelters/:id(.json) 避難所詳細API
  def show
    @shelter = Shelter.find(params[:id])

    return head :not_found if @shelter.blank?
  end
end
