json.success true
json.user do
  json.provider current_user.provider
  json.upload_image current_user.image?
  json.image_url do
    json.mini "http://localhost:3000#{current_user.image_url(:mini)}"
    json.small "http://localhost:3000#{current_user.image_url(:small)}"
    json.medium "http://localhost:3000#{current_user.image_url(:medium)}"
    json.large "http://localhost:3000#{current_user.image_url(:large)}"
    json.xlarge "http://localhost:3000#{current_user.image_url(:xlarge)}"
  end
  json.name current_user.name
  json.email current_user.email
  json.address current_user.address
  json.profile current_user.profile
  json.username current_user.username
end
