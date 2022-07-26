json.success true

json.families do
  json.array! @families do |family|
    json.id family.id
    json.sex family.sex
    json.sex_i18n family.sex_i18n
    json.age family.age
    json.age_i18n family.age_i18n
  end
end
