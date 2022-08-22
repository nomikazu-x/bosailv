class Api::V1::TaskCompletesController < Api::V1::ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  # POST /api/v1/tasks/:id/task_complete/create(.json) 防災タスク完了API(処理)
  def create
    task = Task.find(params[:id])

    if task
      ActiveRecord::Base.transaction do
        current_user.task_complete!(task)
        # ポイント獲得
        PointRecorder.new(current_user).record(Settings['task_complete_obtained_point'])

        render './api/v1/task_completes/success', locals: { notice: I18n.t('notice.task_complete.create') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.task_complete.create') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/tasks/:id/task_complete/delete(.json) 防災タスク完了解除API(処理)
  def destroy
    task = Task.find(params[:id])

    if task
      ActiveRecord::Base.transaction do
        current_user.task_uncomplete!(task)
        # ポイントを減らす
        PointRecorder.new(current_user).delete_record(Settings['task_complete_obtained_point'])

        render './api/v1/task_completes/success', locals: { notice: I18n.t('notice.task_complete.destroy') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.task_complete.destroy') }, status: :unprocessable_entity
    end
  end
end
