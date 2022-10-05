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
        # json.mini "#{@article.user.image_url(:mini)}"
        json.small "#{article_comment.user.image_url(:small)}"
        # json.medium "#{@article.user.image_url(:medium)}"
        # json.large "#{@article.user.image_url(:large)}"
        # json.xlarge "#{@article.user.image_url(:xlarge)}"
      end
    end
  end
end
