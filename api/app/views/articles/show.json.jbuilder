json.success true
json.article do
  json.id @article.id
  json.title @article.title
  json.content @article.content
  json.created_at @article.created_at
  json.updated_at @article.updated_at
  json.is_favorited current_user&.favorite?(@article)
end
