json.success true

if current_user.present?
  json.user do
    json.provider current_user.provider
    json.upload_image current_user.image?
    json.image_url do
      json.mini "#{Settings['base_image_url']}#{current_user.image_url(:mini)}"
      json.small "#{Settings['base_image_url']}#{current_user.image_url(:small)}"
      json.medium "#{Settings['base_image_url']}#{current_user.image_url(:medium)}"
      json.large "#{Settings['base_image_url']}#{current_user.image_url(:large)}"
      json.xlarge "#{Settings['base_image_url']}#{current_user.image_url(:xlarge)}"
    end
    json.id current_user.id
    json.name current_user.name
    json.email current_user.email
    json.username current_user.username
    json.level current_user.level
    json.lifelong_point current_user.lifelong_point
    json.admin current_user.is_admin?
    if current_user.prefecture_id.present?
      json.prefecture do
        json.id @prefecture.id
        json.name @prefecture.name
      end
    end
    if current_user.city_id.present?
      json.city do
        json.id @city.id
        json.name @city.name
      end
    end
    json.point_to_next current_user.point_to_next
    json.profile current_user.profile if current_user.profile.present?
    json.destroy_schedule_at current_user.destroy_schedule_at
    json.infomation_unread_count current_user.infomation_unread_count
    json.required_point @required_point
    json.is_completed_sns_tasks current_user.prepare_task_profile.sns_tasks.raw == 2097151
    json.is_completed_house_tasks current_user.prepare_task_profile.house_tasks.raw == 134217727
    json.is_completed_family_rules_tasks current_user.is_completed_family_rule_tasks?(current_user)
    json.is_family_present current_user.families.present?
    json.is_hazard_map_confirmed current_user.task_profile.hazard_map_confirmed?
  end
end

json.notice notice if notice.present?
