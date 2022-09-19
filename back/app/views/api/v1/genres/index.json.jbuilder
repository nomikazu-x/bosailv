json.success true

json.genres do
  json.array! @genres do |genre|
    json.id genre.id
    json.name genre.name
    json.icon genre.icon
    json.image_url do
      json.large "#{Settings['base_image_url']}#{genre.image_url(:large)}"
      json.xlarge "#{Settings['base_image_url']}#{genre.image_url(:xlarge)}"
      json.xxlarge "#{Settings['base_image_url']}#{genre.image_url(:xxlarge)}"
    end
    json.articles do
      json.array! genre.articles.first(3) do |article|
        json.id article.id
        json.title article.title
        json.content article.content
        json.created_at article.created_at
        json.updated_at article.updated_at
        json.thumbnail_url do
          json.large "#{Settings['base_image_url']}#{article.thumbnail_url(:large)}"
          json.xlarge "#{Settings['base_image_url']}#{article.thumbnail_url(:xlarge)}"
          json.xxlarge "#{Settings['base_image_url']}#{article.thumbnail_url(:xxlarge)}"
        end
      end
    end
  end
end
