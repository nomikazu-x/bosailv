json.success true
if @comment.present?
  json.comment do
    json.content @comment.content
  end
end
json.notice notice if notice.present?
