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
    json.infomation_unread_count current_user.infomation_unread_count
  end
end
json.notice notice if notice.present?
