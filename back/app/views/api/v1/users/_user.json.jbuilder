json.user do
  json.provider user.provider
  json.upload_image user.image?
  json.image_url do
    json.mini "#{user.image_url(:mini)}"
    json.small "#{user.image_url(:small)}"
    json.medium "#{user.image_url(:medium)}"
    json.large "#{user.image_url(:large)}"
    json.xlarge "#{user.image_url(:xlarge)}"
  end
  json.id user.id
  json.name user.name
  json.email user.email
  json.username user.username
  json.level user.level
  json.lifelong_point user.lifelong_point
  json.admin user.is_admin?
  if user.prefecture_id.present?
    json.prefecture do
      json.id Prefecture.find(user.prefecture_id).id
      json.name Prefecture.find(user.prefecture_id).name
    end
  end
  if user.city_id.present?
    json.city do
      json.id City.find(user.city_id).id
      json.name City.find(user.city_id).name
    end
  end
  json.point_to_next user.point_to_next
  json.profile user.profile if user.profile.present?
  json.destroy_schedule_at user.destroy_schedule_at
  json.infomation_unread_count user.infomation_unread_count

  json.required_point RequiredPoint.find_by(level: user.level).point

  json.is_completed_sns_tasks user.prepare_task_profile.sns_tasks.raw == Settings['maximum_sns_task']
  json.is_completed_house_tasks user.prepare_task_profile.house_tasks.raw == Settings['maximum_house_task']
  json.is_completed_family_rules_tasks user.is_completed_family_rule_tasks?(user)
  json.is_completed_emergency_contact_task user.emergency_contacts.present?
  json.is_completed_stock_tasks user.prepare_task_profile.stock_tasks.raw == Settings['maximum_stock_task']
  json.is_family_present user.families.present?
  json.is_hazard_map_confirmed user.task_profile.hazard_map_confirmed?
  json.is_shelter_registered user.registered_shelters.present?
  json.is_max_emergency_contact user.emergency_contacts.count == Settings['maximum_emergency_contacts_length']
  json.is_max_registered_shelters user.registered_shelters.count == Settings['maximum_registered_shelters_length']
end
