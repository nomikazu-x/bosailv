json.success true

if current_user.present?
  json.sns_tasks do
    json.array! TaskProfile.sns_tasks.pairs do |sns_task|
      json.name sns_task[0]
      json.value sns_task[1]
      json.is_completed @task_profile.sns_tasks.set?(sns_task[1]) if @task_profile.present?
    end
  end

  json.house_tasks do
    json.array! TaskProfile.house_tasks.pairs do |house_task|
      json.name house_task[0]
      json.value house_task[1]
      json.is_completed @task_profile.house_tasks.set?(house_task[1]) if @task_profile.present?
    end
  end
end
