json.success true
json.article do
  json.user @article.user
  json.title @article.title
  json.content @article.content
  json.created_at @article.created_at
  json.updated_at @article.updated_at
end
