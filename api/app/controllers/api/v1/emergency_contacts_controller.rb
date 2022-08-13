class Api::V1::EmergencyContactsController < Api::V1::ApplicationController

  # GET /api/v1/emergency_contacts(.json) 緊急連絡先一覧API
  def index
    @emergency_contacts = current_user.emergency_contacts
  end

  # POST /api/v1/emergency_contacts/create(.json) 緊急連絡先作成API(処理)
  def create
    @emergency_contact = current_user.emergency_contacts.build(emergency_contact_params)

    if @emergency_contact.save
      ActiveRecord::Base.transaction do
        # ポイント獲得
        PointRecorder.new(current_user).record(Settings['emergency_contact_create_obtained_point'])
        # 次のレベルに必要なポイントを返す
        @required_point = RequiredPoint.find_by(level: current_user.level).point
        render './api/v1/emergency_contacts/success', locals: { notice: I18n.t('notice.emergency_contact.create') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.emergency_contact.create') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/emergency_contacts/:id/delete(.json) 緊急連絡先削除API(処理)
  def destroy
    emergency_contact = current_user.emergency_contacts.find(params[:id])

    if emergency_contact.destroy
      ActiveRecord::Base.transaction do
        # ポイントを減らす
        PointRecorder.new(current_user).delete_record(Settings['emergency_contact_create_obtained_point'])
        # 次のレベルに必要なポイントを返す
        @required_point = RequiredPoint.find_by(level: current_user.level).point
        render './api/v1/emergency_contacts/success', locals: { notice: I18n.t('notice.emergency_contact.destroy') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.emergency_contact.destroy') }, status: :unprocessable_entity
    end
  end

  private

  def emergency_contact_params
    params.require(:emergency_contact).permit(:name, :phone_number)
  end
end
