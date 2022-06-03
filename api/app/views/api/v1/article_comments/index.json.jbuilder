json.success true
json.comments do
  json.array! article_comments do |article_comment|
    json.id article_comment.id
    json.content article_comment.content
    json.created_at article_comment.created_at
    json.updated_at article_comment.updated_at
  end
end
