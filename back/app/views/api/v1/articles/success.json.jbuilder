json.success true

if @article.present?
  json.article do
    json.id @article.id
    json.title @article.title
    json.content @article.content
    json.thumbnail_url do
      json.large "#{@article.thumbnail_url(:large)}"
      json.xlarge "#{@article.thumbnail_url(:xlarge)}"
      json.xxlarge "#{@article.thumbnail_url(:xxlarge)}"
    end
    json.created_at @article.created_at
    json.updated_at @article.updated_at
    json.partial! 'api/v1/users/user', user: current_user
    json.genres do
      json.array! @article.genres do |genre|
        json.id genre.id
        json.name genre.name
      end
    end
  end
end

json.notice notice if notice.present?
