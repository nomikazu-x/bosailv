json.success true

json.comments do
  json.array! @article_comments do |article_comment|
    json.id article_comment.id
    json.content article_comment.content
    json.created_at l(article_comment.created_at, format: :json)
    json.user do
      json.partial! 'api/v1/auth/user', user: article_comment.user, use_email: false
    end
  end
end
