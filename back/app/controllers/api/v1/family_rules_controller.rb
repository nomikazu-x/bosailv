class Api::V1::FamilyRulesController < Api::V1::ApplicationController
  before_action :authenticate_user!, only: %i[show create update destroy]
  before_action :set_family_rule, only: %i[show update destroy]

  # GET /api/v1/family_rule(.json) 家族ルール取得API
  # def show
  # end

  # POST /api/v1/family_rules/create(.json) 家族ルール作成API(処理)
  def create
    @family_rule = current_user.build_family_rule(family_rule_params)
    if @family_rule.save
      ActiveRecord::Base.transaction do
        # ポイント獲得
        PointRecorder.new(current_user).record(Settings['family_rule_create_obtained_point'])

        render './api/v1/auth/success', locals: { notice: I18n.t('notice.family_rule.create') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.family_rule.create') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/family_rules/update(.json) 家族ルール更新API(処理)
  def update
    if @family_rule.update(family_rule_params)
      render './api/v1/auth/success', locals: { notice: I18n.t('notice.family_rule.update') }
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.family_rule.update') }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/family_rules/delete(.json) 家族ルールリセットAPI(処理)
  def destroy
    if @family_rule.destroy!
      ActiveRecord::Base.transaction do
        # ポイントを減らす
        PointRecorder.new(current_user).delete_record(Settings['family_rule_create_obtained_point'])

        render './api/v1/auth/success', locals: { notice: I18n.t('notice.family_rule.destroy') }
      end
    else
      render './api/v1/failure', locals: { alert: I18n.t('alert.family_rule.destroy') }, status: :unprocessable_entity
    end
  end

  private

  def set_family_rule
    @family_rule = current_user.family_rule

    return head :not_found if @family_rule.blank?
  end

  def family_rule_params
    params.require(:family_rule).permit(
      :contact_means_memo,
      :emergency_measure_memo,
      :family_role_memo,
      :leave_home_memo,
      :refuge_memo
    )
  end
end
