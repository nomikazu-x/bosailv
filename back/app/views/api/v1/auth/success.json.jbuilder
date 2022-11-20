json.success true

if current_user.present?
  json.user do
    json.partial! 'api/v1/auth/current_user', use_email: false
  end
end

json.notice notice if notice.present?
json.alert alert if defined? alert
