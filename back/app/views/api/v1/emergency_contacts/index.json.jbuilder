json.success true

json.emergency_contacts do
  json.array! @emergency_contacts do |emergency_contact|
    json.id emergency_contact.id
    json.name emergency_contact.name
    json.phone_number emergency_contact.phone_number
  end
end
