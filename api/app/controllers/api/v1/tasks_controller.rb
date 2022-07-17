class Api::V1::TasksController < Api::V1::ApplicationController

  # GET /api/v1/tasks(.json) ジャンル一覧API
  def index
    @tasks = Task.all
    render './api/v1/tasks/index'
  end

  # GET /api/v1/tasks/:id(.json) ジャンル詳細API
  def show
    @task = Task.find(params[:id])
    render './api/v1/tasks/show'
  end
end
