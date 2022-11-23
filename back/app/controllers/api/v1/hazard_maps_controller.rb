class Api::V1::HazardMapsController < Api::V1::ApplicationController

  # GET /api/v1/hazard_map(.json) ハザードマップ詳細API
  def show
    return if params[:prefecture_id].blank? && params[:city_id].blank?

    @prefecture = Prefecture.find(params[:prefecture_id])
    @city = City.find(params[:city_id])
    @hazard_map = @city.hazard_map

    return head :not_found if @hazard_map.blank?
  end
end
