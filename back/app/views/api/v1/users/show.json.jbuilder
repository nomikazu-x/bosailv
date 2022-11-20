json.success true

json.user do
  json.partial! 'api/v1/auth/user', user: @user, use_email: false
end
