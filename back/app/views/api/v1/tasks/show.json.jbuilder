json.success true

json.task do
  json.id @task.id
  json.title @task.title
  json.summary @task.summary
  json.body @task.body
  json.icon @task.icon
  json.image_url do
    json.large "#{@task.image_url(:large)}"
    json.xlarge "#{@task.image_url(:xlarge)}"
    json.xxlarge "#{@task.image_url(:xxlarge)}"
  end
  json.is_completed current_user&.task_complete?(@task)
end
