json.success true

if @article_comment.present?
  json.comment do
    json.id @article_comment.id
    json.content @article_comment.content
    json.created_at @article_comment.created_at
    json.user do
      json.partial! 'api/v1/auth/current_user', user: current_user, use_email: false
    end
  end
end

json.notice notice if notice.present?
