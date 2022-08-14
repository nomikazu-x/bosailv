json.success true

if current_user.present?
  json.partial! 'api/v1/users/user', user: current_user
end

json.notice notice if notice.present?
