json.success true

json.genre do
  json.id @genre.id
  json.name @genre.name
  json.description @genre.description
  json.image_url do
    json.large "#{@genre.image_url(:large)}"
    json.xlarge "#{@genre.image_url(:xlarge)}"
    json.xxlarge "#{@genre.image_url(:xxlarge)}"
  end
end

if @articles.exists?
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
      json.genres do
        json.array! article.genres do |genre|
          json.id genre.id
          json.name genre.name
        end
      end
      json.thumbnail_url do
        json.large "#{article.thumbnail_url(:large)}"
        json.xlarge "#{article.thumbnail_url(:xlarge)}"
        json.xxlarge "#{article.thumbnail_url(:xxlarge)}"
      end
      json.created_at article.created_at
      json.updated_at article.updated_at
    end
  end
end
