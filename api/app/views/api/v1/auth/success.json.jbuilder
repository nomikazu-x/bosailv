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
    json.profile current_user.profile
    json.prefecture Prefecture.find(current_user.prefecture_id).name
    json.city City.find(current_user.city_id).name
    json.point_to_next current_user.point_to_next
    json.profile current_user.profile if current_user.profile.present?
    json.infomation_unread_count current_user.infomation_unread_count
    json.required_point RequiredPoint.find_by(level: current_user.level).required_point
  end
end
json.notice notice if notice.present?
