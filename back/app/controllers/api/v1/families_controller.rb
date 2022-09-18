class Api::V1::FamiliesController < Api::V1::ApplicationController

  # GET /api/v1/families(.json) 緊急連絡先一覧API
  def index
    @families = current_user.families
  end

  # POST /api/v1/families/create(.json) 緊急連絡先作成API(処理)
  def create
    @family = current_user.families.build(family_params)

    if @family.save
      render './api/v1/families/success', locals: { notice: I18n.t('notice.family.create') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.family.create') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/families/:id/delete(.json) 緊急連絡先削除API(処理)
  def destroy
    family = current_user.families.find(params[:id])

    if family.destroy!
      render './api/v1/families/success', locals: { notice: I18n.t('notice.family.destroy') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.family.destroy') }, status: :unprocessable_entity
    end

    if current_user.families.blank?
      current_user.task_profile.update!(stock_tasks: 0)
    end
  end

  private

  def family_params
    params.require(:family).permit(:sex, :age)
  end
end
