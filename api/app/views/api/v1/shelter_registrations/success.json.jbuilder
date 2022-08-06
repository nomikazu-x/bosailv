json.success true

json.required_point @required_point

json.user do
  json.id current_user.id
  json.level current_user.level
  json.lifelong_point current_user.lifelong_point
  json.point_to_next current_user.point_to_next
end

json.notice notice if notice.present?
