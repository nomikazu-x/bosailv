class Api::V1::CitiesController < Api::V1::ApplicationController

  # GET /api/v1/set_cities/_id(.json) 選択された都道府県情報をもとに市区町村一覧を取得するAPI
  def set_cities
    cities = Prefecture.find(params[:id]).cities
    render json: cities.all.to_json(only: %i[id name])
  end
end
