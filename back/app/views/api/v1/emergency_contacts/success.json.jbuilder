json.success true

if @emergency_contact.present?
  json.emergency_contact do
    json.id @emergency_contact.id
    json.name @emergency_contact.name
    json.phone_number @emergency_contact.phone_number
  end
end

if current_user.present?
  json.user do
    json.partial! 'api/v1/auth/current_user', use_email: false
  end
end

json.notice notice if notice.present?
