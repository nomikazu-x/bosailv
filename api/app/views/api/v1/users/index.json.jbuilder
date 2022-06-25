json.success true

json.user do
  json.total_count @users.total_count
  json.current_page @users.current_page
  json.total_pages @users.total_pages
  json.limit_value @users.limit_value
end

json.users do
  json.array! @users do |user|
    json.id user.id
    json.image_url do
      json.mini "#{Settings['base_image_url']}#{user.image_url(:mini)}"
      json.small "#{Settings['base_image_url']}#{user.image_url(:small)}"
      json.medium "#{Settings['base_image_url']}#{user.image_url(:medium)}"
      json.large "#{Settings['base_image_url']}#{user.image_url(:large)}"
      json.xlarge "#{Settings['base_image_url']}#{user.image_url(:xlarge)}"
    end
    json.name user.name
    json.level user.level
    json.username user.username
    json.lifelong_point user.lifelong_point
  end
end
