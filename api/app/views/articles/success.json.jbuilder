json.success true
if @article.present?
  json.article do
    json.title @article.title
    json.content @article.content
  end
end
json.notice notice if notice.present?
