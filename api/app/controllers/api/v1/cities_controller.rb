class Api::V1::CitiesController < Api::V1::ApplicationController
  def set_cities
    cities = Prefecture.find(params[:id]).cities
    render json: cities.all.to_json(only: %i[id name])
  end
end
