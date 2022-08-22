class Api::V1::SheltersController < Api::V1::ApplicationController

  # GET /api/v1/shelters(.json) 避難所一覧API
  def index
    if params[:prefecture_id].present?
      @prefecture = Prefecture.find(params[:prefecture_id]).name
      @city = City.find(params[:id]).name
    else
      @prefecture = Prefecture.find(current_user.prefecture_id).name
      @city = City.find(current_user.city_id).name
    end
    @city_name = @prefecture + @city

    @shelters = City.find(params[:id]).shelters.page(params[:page]).per(Settings['default_shelters_limit'])
    @shelters = @shelters.where("#{params[:disaster_type]} = true") if params[:disaster_type]
  end

  # GET /api/v1/shelters/:id(.json) 避難所詳細API
  def show
    @shelter = Shelter.find(params[:id])
  end
end
