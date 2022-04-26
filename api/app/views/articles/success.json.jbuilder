json.success true
if article.present?
  json.article do
    json.user article.user
    json.title article.title
    json.content article.content
    json.address article.address
    json.created_at article.created_at
    json.updated_at article.updated_at
  end
end
json.notice notice if notice.present?
