class Api::V1::Admin::TasksController < Api::V1::ApplicationController
  before_action :redirect_not_admin, only: %i[create update destroy]
  before_action :set_task, only: %i[update destroy]

  # POST /api/v1/admin/tasks/create(.json) 防災タスク作成API
  def create
    task = Task.new(task_params)

    if task.save
      render './api/v1/success', locals: { notice: I18n.t('notice.task.create') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.task.create') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/admin/tasks/:id/update(.json) 防災タスク更新API(処理)
  def update
    task = Task.find(params[:id])

    if task.update(task_params)
      render './api/v1/success', locals: { notice: I18n.t('notice.task.update') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.task.update') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/admin/tasks/:id/delete(.json) 防災タスク削除API
  def destroy
    task = Task.find(params[:id])

    if task.destroy
      render './api/v1/success', locals: { notice: I18n.t('notice.task.destroy') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.task.destroy') }, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :image, :summary, :body, :icon)
  end
end
