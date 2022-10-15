class Api::V1::TaskProfilesController < Api::V1::ApplicationController
  before_action :set_task_profile, only: %i[show update destroy]

  # GET /api/v1/task_profile(.json) タスクプロフィール取得API
  # def show

  # end

  # POST /api/v1/task_profiles/update(.json) タスク更新API(処理)
  def update
    case
    when params[:sns_task]
      task = @task_profile.sns_tasks.set(params[:sns_task])
      if @task_profile.update(params.permit(sns_tasks: task))
        task_complete_point_record(Settings['sns_task_complete_obtained_point'])
      else
        render './api/v1/failure', locals: { alert: I18n.t('alert.user.task_update') }, status: :unprocessable_entity
      end

    when params[:house_task]
      task = @task_profile.house_tasks.set(params[:house_task])
      if @task_profile.update(params.permit(house_tasks: task))
        task_complete_point_record(Settings['house_task_complete_obtained_point'])
      else
        render './api/v1/failure', locals: { alert: I18n.t('alert.user.task_update') }, status: :unprocessable_entity
      end

    when params[:stock_task]
      task = @task_profile.stock_tasks.set(params[:stock_task])
      if @task_profile.update(params.permit(stock_tasks: task))
        task_complete_point_record(Settings['stock_task_complete_obtained_point'])
      else
        render './api/v1/failure', locals: { alert: I18n.t('alert.user.task_update') }, status: :unprocessable_entity
      end

    when params[:hazard_map_confirmed]
      if @task_profile.set_hazard_map_confirm
        ActiveRecord::Base.transaction do
          # ポイント獲得
          PointRecorder.new(current_user).record(Settings['hazard_map_confirm_obtained_point'])
          render './api/v1/task_profiles/success', locals: { notice: I18n.t('notice.user.hazard_map_task_update') }
        end
      else
        render './api/v1/failure', locals: { alert: I18n.t('alert.user.hazard_map_task_update') }, status: :unprocessable_entity
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.user.task_update') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/task_profiles/delete(.json) タスクリセットAPI(処理)
  def destroy
    case 
    when params[:sns_task]
      task = @task_profile.sns_tasks.unset(params[:sns_task].to_sym) # Tips unsetメソッドの場合はシンボルにする必要がある。
      if @task_profile.update(params.permit(sns_tasks: task))
        task_complete_point_delete_record(Settings['sns_task_complete_obtained_point'])
      else
        render './api/v1/failure', locals: { alert: I18n.t('alert.user.task_destroy') }, status: :unprocessable_entity
      end

    when params[:house_task]
      task = @task_profile.house_tasks.unset(params[:house_task].to_sym) # Tips unsetメソッドの場合はシンボルにする必要がある。
      if @task_profile.update(params.permit(house_tasks: task))
          task_complete_point_delete_record(Settings['house_task_complete_obtained_point'])
      else
        render './api/v1/failure', locals: { alert: I18n.t('alert.user.task_destroy') }, status: :unprocessable_entity
      end

    when params[:stock_task]
      task = @task_profile.stock_tasks.unset(params[:stock_task].to_sym) # Tips unsetメソッドの場合はシンボルにする必要がある。
      if @task_profile.update(params.permit(stock_tasks: task))
        task_complete_point_delete_record(Settings['stock_task_complete_obtained_point'])
      else
        render './api/v1/failure', locals: { alert: I18n.t('alert.user.task_destroy') }, status: :unprocessable_entity
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.user.task_destroy') }, status: :unprocessable_entity
    end
  end

  private

  def set_task_profile
    @task_profile = current_user.prepare_task_profile
  end

  def task_complete_point_record(obtained_point)
    ActiveRecord::Base.transaction do
      # ポイント獲得
      PointRecorder.new(current_user).record(obtained_point)
      update_auth_header # 成功時のみ認証情報を返す
      render './api/v1/task_profiles/success', locals: { notice: I18n.t('notice.user.task_update') }
    end
  end

  def task_complete_point_delete_record(obtained_point)
    ActiveRecord::Base.transaction do
      # ポイントを減らす
      PointRecorder.new(current_user).delete_record(obtained_point)
      update_auth_header # 成功時のみ認証情報を返す
      render './api/v1/task_profiles/success', locals: { notice: I18n.t('notice.user.task_destroy') }
    end
  end
end
