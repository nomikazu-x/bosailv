class Api::V1::HealthCheckController < Api::V1::ApplicationController
  def index
    head 200
  end
end