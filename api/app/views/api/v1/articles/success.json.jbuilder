json.success true
if @article.present?
  json.article do
    json.title @article.title
    json.content @article.content
    json.category @article.category
  end
end
json.notice notice if notice.present?
