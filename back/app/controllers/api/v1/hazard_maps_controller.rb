class Api::V1::HazardMapsController < Api::V1::ApplicationController

  # GET /api/v1/hazard_map(.json) ハザードマップ詳細API
  def show
    @prefecture = Prefecture.find(params[:prefecture_id])
    @city = City.find(params[:city_id])
    @hazard_map = @city.hazard_map
  end
end
