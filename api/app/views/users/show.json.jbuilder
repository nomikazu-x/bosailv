if current_api_v1_user.present?
  json.user do
    json.id current_api_v1_user.id
    json.name current_api_v1_user.name
    json.nickname current_api_v1_user.nickname
    json.image current_api_v1_user.image
    json.confirmed_at current_api_v1_user.confirmed_at
    json.updated_at current_api_v1_user.updated_at
  end
end
