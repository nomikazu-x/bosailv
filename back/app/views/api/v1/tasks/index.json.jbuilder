json.success true

json.tasks do
  json.array! @tasks do |task|
    json.id task.id
    json.title task.title
    json.summary task.summary
    json.icon task.icon
    json.image_url do
      json.large "#{Settings['base_image_url']}#{task.image_url(:large)}"
      json.xlarge "#{Settings['base_image_url']}#{task.image_url(:xlarge)}"
      json.xxlarge "#{Settings['base_image_url']}#{task.image_url(:xxlarge)}"
    end
    json.is_completed @user&.task_complete?(task)
  end
end
