json.success true
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
  json.name current_user.name
  json.email current_user.email
  json.level current_user.level
  json.lifelong_point current_user.lifelong_point
  json.point_to_next current_user.point_to_next
  json.infomation_unread_count current_user.infomation_unread_count
  json.created_at current_user.created_at.present? ? l(current_user.created_at, format: :json) : nil
end
