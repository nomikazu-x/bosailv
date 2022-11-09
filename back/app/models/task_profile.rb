# == Schema Information
#
# Table name: task_profiles
#
#  id                                              :bigint           not null, primary key
#  hazard_map_confirmed_at(ハザードマップ確認日時) :datetime
#  house_tasks(家庭関係防災タスク)                 :bigint           default(0), not null
#  sns_tasks(SNS関係防災タスク)                    :bigint           default(0), not null
#  stock_tasks(備蓄関係防災タスク)                 :bigint           default(0), not null
#  created_at                                      :datetime         not null
#  updated_at                                      :datetime         not null
#  user_id(ユーザーID)                             :bigint           not null
#
# Indexes
#
#  index_task_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class TaskProfile < ApplicationRecord
  belongs_to :user

  flag :sns_tasks,   %i[kantei_saigai fdma_japan modjapan_jp cao_bousai mlit_japan jgsdf_pr jma_kishou jmaxmlalerts yahoo_weather wni_jp earthquake_jp tenkijp_jishin un_nerv nhk_news nhk_seikatsu twitterlifeline nikkei yomiuri_online mainichijpnews asahi japantimes]
  flag :house_tasks, %i[tv_rack_fixed tv_position fridge_fixed fridge_position not_put_object range_table_fixed window_glass home_electronics_fixed l_type_fitting pole_type_combination pole_type_reinforcement pole_type_position stopper_type_position plasterboard_reinforcement furniture_concatenation glass_film releasing_protection heavy_object_position select_fixed_equipment refuge_aisle_allocation caster_furniture_lock caster_furniture_fixed table_non_slip aquarium_fixed suspended_lighting_fixed drawer_motion_protection door_near_furniture]
  flag :stock_tasks, %i[water retort_rice retort_food nutritional_supplement confectionery canned_fruits wet_wipes alcohol_spray mask medicine wrap plastic_bag aluminum_foil toilet_paper tissue_paper flashlight dry_cell_battery lighter body_warmer contact_lenses battery_charger gloves newspaper radio simple_toilet water_supply_bag sanitary_item milk_powder diaper baby_wipe baby_bottle denture_cleaner prescription_drug ruck_sack]

  validates :user_id, presence: true

  # ハザードマップ確認済みか返却
  def hazard_map_confirmed?
    hazard_map_confirmed_at.present?
  end

  # ハザードマップ確認
  def set_hazard_map_confirm
    update!(hazard_map_confirmed_at: Time.current)
  end
end
