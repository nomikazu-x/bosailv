class InfomationsController < ApiController
  def index
    @infomations = Infomation.all
  end

  def show
    @infomation = Infomation.find(params[:id])
  end
end
