class Api::V1::PrefecturesController < Api::V1::ApplicationController

  # GET /api/v1/prefectures(.json) 都道府県一覧API
  def index
    @prefectures = Prefecture.all
  end
end
