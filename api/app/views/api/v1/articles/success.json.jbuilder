json.success true

json.required_point @required_point

if @article.present?
  json.article do
    json.id @article.id
    json.title @article.title
    json.content @article.content
    json.thumbnail_url do
      json.large "#{Settings['base_image_url']}#{@article.thumbnail_url(:large)}"
      json.xlarge "#{Settings['base_image_url']}#{@article.thumbnail_url(:xlarge)}"
      json.xxlarge "#{Settings['base_image_url']}#{@article.thumbnail_url(:xxlarge)}"
    end
    json.created_at @article.created_at
    json.updated_at @article.updated_at
    json.user do
      json.id @article.user.id
      json.level @article.user.level
      json.lifelong_point @article.user.lifelong_point
      json.point_to_next @article.user.point_to_next
    end
  end
end

json.notice notice if notice.present?
