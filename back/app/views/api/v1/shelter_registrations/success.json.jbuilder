json.success true

json.partial! 'api/v1/users/user', user: current_user

json.notice notice if notice.present?
