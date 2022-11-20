json.partial! 'api/v1/auth/user', user: current_user, use_email: use_email

json.provider current_user.provider
json.upload_image current_user.image?

## 管理者フラグ
json.admin current_user.is_admin?

## 家族情報の有無
json.is_family_present current_user.families.present?

## 登録情報の上限達成状況
json.is_max_emergency_contact current_user.emergency_contacts.count == Settings['maximum_emergency_contacts_length']
json.is_max_registered_shelters current_user.registered_shelters.count == Settings['maximum_registered_shelters_length']

## 削除予定
json.destroy_schedule_at current_user.destroy_schedule_at.present? ? l(current_user.destroy_schedule_at, format: :json) : nil
## お知らせ
json.infomation_unread_count current_user.infomation_unread_count
