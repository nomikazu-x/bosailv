json.success true
if @article_comment.present?
  json.comment do
    json.content @article_comment.content
  end
end
json.notice notice if notice.present?
