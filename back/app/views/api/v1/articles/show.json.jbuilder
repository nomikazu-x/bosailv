json.success true

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
  json.is_favorited current_user&.article_favorite?(@article)
  json.genres do
    json.array! @article.genres do |genre|
      json.id genre.id
      json.name genre.name
    end
  end
  json.user do
    json.id @article.user.id
    json.name @article.user.name
    json.username @article.user.username
    json.image_url do
      json.mini "#{Settings['base_image_url']}#{@article.user.image_url(:mini)}"
      json.small "#{Settings['base_image_url']}#{@article.user.image_url(:small)}"
      json.medium "#{Settings['base_image_url']}#{@article.user.image_url(:medium)}"
      json.large "#{Settings['base_image_url']}#{@article.user.image_url(:large)}"
      json.xlarge "#{Settings['base_image_url']}#{@article.user.image_url(:xlarge)}"
    end
  end
  json.likers do
    json.array! @article.likers do |liker|
      json.id liker.id
      json.name liker.name
      json.username liker.username
      json.image_url do
        json.mini "#{Settings['base_image_url']}#{liker.image_url(:mini)}"
        json.small "#{Settings['base_image_url']}#{liker.image_url(:small)}"
        json.medium "#{Settings['base_image_url']}#{liker.image_url(:medium)}"
        json.large "#{Settings['base_image_url']}#{liker.image_url(:large)}"
        json.xlarge "#{Settings['base_image_url']}#{liker.image_url(:xlarge)}"
      end
    end
  end
end
