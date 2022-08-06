class Api::V1::SheltersController < Api::V1::ApplicationController

  # GET /api/v1/shelters(.json) 避難所一覧API
  def index
    @shelters = City.find(params[:id]).shelters.page(params[:page]).per(Settings['default_shelters_limit'])
  end

  # GET /api/v1/shelters/:id(.json) 避難所詳細API
  def show
    @shelter = Shelter.find(params[:id])
  end
end
