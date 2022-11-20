json.success true

if @family.present?
  json.family do
    json.id @family.id
    json.sex @family.sex
    json.sex_i18n @family.sex_i18n
    json.age @family.age
    json.age_i18n @family.age_i18n
  end
end

if current_user.present?
  json.user do
    json.partial! 'api/v1/auth/current_user', use_email: false
  end
end

json.notice notice if notice.present?
