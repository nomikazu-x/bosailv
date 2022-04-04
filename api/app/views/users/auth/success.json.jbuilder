json.success true
json.user do
  json.id current_user.id
  json.name current_user.name
  json.nickname current_user.nickname
  json.image current_user.image
  json.confirmed_at current_user.confirmed_at
  json.updated_at current_user.updated_at
end
