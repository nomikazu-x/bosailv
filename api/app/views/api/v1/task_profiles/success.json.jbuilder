json.success true

json.required_point @required_point

json.user do
  json.id current_user.id
  json.level current_user.level
  json.lifelong_point current_user.lifelong_point
  json.point_to_next current_user.point_to_next
  json.sns_tasks do
    json.array! TaskProfile.sns_tasks.pairs do |task|
      json.name task[0]
      json.value task[1]
      json.is_completed @task_profile.sns_tasks.set?(task[1])
    end
  end
  json.is_completed_sns_tasks current_user.prepare_task_profile.sns_tasks.raw == 2097151

  json.house_tasks do
    json.array! TaskProfile.house_tasks.pairs do |task|
      json.name task[0]
      json.value task[1]
      json.is_completed @task_profile.house_tasks.set?(task[1])
    end
  end
  json.is_completed_house_tasks current_user.prepare_task_profile.house_tasks.raw == 134217727
end

json.notice notice if notice.present?
