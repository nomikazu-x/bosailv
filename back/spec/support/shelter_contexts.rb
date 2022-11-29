shared_context '避難所一覧作成' do |default_shelters_count, favorite_exist_count|
  before_all do
    # 避難所作成
    @all_shelters = FactoryBot.create_list(:shelter, default_shelters_count, city: city)

    # お気に入りしているユーザーあり
    @other_user = FactoryBot.create(:user)
    @all_favorite_shelters = @all_shelters
    if favorite_exist_count.positive?
      @all_favorite_shelters.each do |shelter|
        FactoryBot.create(:shelter_favorite, shelter: shelter, user: @other_user)
      end
    end
  end
end
