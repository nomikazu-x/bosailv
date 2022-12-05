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
    json.name user.name
    json.level user.level
    json.username user.username
    json.lifelong_point user.lifelong_point
    json.image_url do
      json.mini "#{user.image_url(:mini)}"
      json.small "#{user.image_url(:small)}"
      json.medium "#{user.image_url(:medium)}"
      json.large "#{user.image_url(:large)}"
      json.xlarge "#{user.image_url(:xlarge)}"
    end
  end
end
