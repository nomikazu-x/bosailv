json.success true

if @emergency_contact.present?
  json.emergency_contact do
    json.id @emergency_contact.id
    json.name @emergency_contact.name
    json.phone_number @emergency_contact.phone_number
  end
end

json.partial! 'api/v1/users/user', user: current_user

json.notice notice if notice.present?
