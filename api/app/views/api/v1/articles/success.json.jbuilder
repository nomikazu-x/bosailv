json.success true
json.required_point RequiredPoint.find_by(level: @article.user.level).required_point
if @article.present?
  json.article do
    json.title @article.title
    json.content @article.content
    json.category @article.category
    json.user do
      json.level @article.user.level
      json.lifelong_point @article.user.lifelong_point
      json.point_to_next @article.user.point_to_next
    end
  end
end
json.notice notice if notice.present?
