class Api::V1::HazardMapsController < Api::V1::ApplicationController

  # GET /api/v1/hazard_map(.json) ハザードマップ詳細API
  def show
    @hazard_map = City.find(params[:id]).hazard_map
  end
end
