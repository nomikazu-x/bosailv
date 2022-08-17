class Api::V1::HazardMapsController < Api::V1::ApplicationController

  # GET /api/v1/hazard_map(.json) ハザードマップ詳細API
  def show
    if params[:prefecture_id].present?
      @prefecture = Prefecture.find(params[:prefecture_id]).name
      @city = City.find(params[:id]).name
    else
      @prefecture = Prefecture.find(current_user.prefecture_id).name
      @city = City.find(current_user.city_id).name
    end

    @city_name = @prefecture + @city
    @hazard_map = City.find(params[:id]).hazard_map
  end
end
