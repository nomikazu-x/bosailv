json.success true

json.genre do
  json.id @genre.id
  json.name @genre.name
  json.description @genre.description
  json.icon @genre.icon
  json.image_url do
    json.large "#{@genre.image_url(:large)}"
    json.xlarge "#{@genre.image_url(:xlarge)}"
  end 
end

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
    json.created_at article.created_at
    json.updated_at article.updated_at
    json.thumbnail_url do
      json.large "#{article.thumbnail_url(:large)}"
      json.xlarge "#{article.thumbnail_url(:xlarge)}"
      json.xxlarge "#{article.thumbnail_url(:xxlarge)}"
    end
  end
end
