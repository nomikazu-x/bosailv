json.success true

json.article do
  json.total_count @articles.total_count
  json.current_page @articles.current_page
  json.total_pages @articles.total_pages
  json.limit_value @articles.limit_value
end

json.articles do
  json.array! @articles do |article|
    json.id article.id
    json.title article.title
    json.content article.content
    json.created_at l(article.created_at, format: :json)
    json.updated_at article.updated_at.present? ? l(article.updated_at, format: :json) : nil
    json.thumbnail_url do
      json.large "#{article.thumbnail_url(:large)}"
      json.xlarge "#{article.thumbnail_url(:xlarge)}"
      json.xxlarge "#{article.thumbnail_url(:xxlarge)}"
    end
  end
end
