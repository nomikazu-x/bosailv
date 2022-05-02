json.success true
json.article do
  json.id @article.id
  json.title @article.title
  json.content @article.content
  json.created_at @article.created_at
  json.updated_at @article.updated_at
  json.is_favorited current_user&.favorite?(@article)
  json.comments do
    json.array! @article.comments do |comment|
      json.id comment.id
      json.content comment.content
      json.created_at comment.created_at
      json.updated_at comment.updated_at
    end
  end
end
