json.success true

json.comments do
  json.array! @article_comments do |article_comment|
    json.id article_comment.id
    json.content article_comment.content
    json.created_at article_comment.created_at
    json.updated_at article_comment.updated_at
    json.user do
      json.id article_comment.user.id
      json.name article_comment.user.name
      json.image_url do
        # json.mini "#{Settings['base_image_url']}#{@article.user.image_url(:mini)}"
        json.small "#{Settings['base_image_url']}#{article_comment.user.image_url(:small)}"
        # json.medium "#{Settings['base_image_url']}#{@article.user.image_url(:medium)}"
        # json.large "#{Settings['base_image_url']}#{@article.user.image_url(:large)}"
        # json.xlarge "#{Settings['base_image_url']}#{@article.user.image_url(:xlarge)}"
      end
    end
  end
end
