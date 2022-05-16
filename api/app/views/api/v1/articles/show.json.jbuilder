json.success true
json.article do
  json.id @article.id
  json.title @article.title
  json.content @article.content
  json.created_at @article.created_at
  json.updated_at @article.updated_at
  json.is_favorited current_user&.article_favorite?(@article)
  json.comments do
    json.array! @article.article_comments do |article_comment|
      json.id article_comment.id
      json.content article_comment.content
      json.created_at article_comment.created_at
      json.updated_at article_comment.updated_at
    end
  end
end
