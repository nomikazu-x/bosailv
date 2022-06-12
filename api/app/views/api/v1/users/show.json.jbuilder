json.success true
json.required_point RequiredPoint.find_by(level: @user.level).required_point
json.prefectures do
  json.array! Prefecture.all do |prefecture|
    json.id prefecture.id
    json.name prefecture.name
  end
end

json.user do
  json.provider @user.provider
  json.upload_image @user.image?
  json.image_url do
    json.mini "#{Settings['base_image_url']}#{@user.image_url(:mini)}"
    json.small "#{Settings['base_image_url']}#{@user.image_url(:small)}"
    json.medium "#{Settings['base_image_url']}#{@user.image_url(:medium)}"
    json.large "#{Settings['base_image_url']}#{@user.image_url(:large)}"
    json.xlarge "#{Settings['base_image_url']}#{@user.image_url(:xlarge)}"
  end
  json.id @user.id
  json.name @user.name
  json.email @user.email
  json.level @user.level
  json.username @user.username
  json.profile @user.profile
  json.prefecture @user.prefecture_id
  json.city @user.city_id
  json.lifelong_point @user.lifelong_point
  json.point_to_next @user.point_to_next
  json.infomation_unread_count @user.infomation_unread_count
  json.created_at @user.created_at.present? ? l(@user.created_at, format: :json) : nil
  if @user.articles.exists?
    json.articles do
      json.array! @user.articles do |article|
        json.id article.id
        json.title article.title
        json.content article.content
        json.category article.category
        json.thumbnail_url do
          json.large "#{Settings['base_image_url']}#{article.thumbnail_url(:large)}"
          json.xlarge "#{Settings['base_image_url']}#{article.thumbnail_url(:xlarge)}"
          json.xxlarge "#{Settings['base_image_url']}#{article.thumbnail_url(:xxlarge)}"
        end
        json.created_at article.created_at
        json.updated_at article.updated_at
      end
    end
  end
end
