json.success true

if @emergency_contact.present?
  json.emergency_contact do
    json.id @emergency_contact.id
    json.name @emergency_contact.name
    json.phone_number @emergency_contact.phone_number
  end
end

json.notice notice if notice.present?
