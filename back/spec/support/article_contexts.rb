shared_context '記事一覧作成' do |genre_exist_count, genre_none_count, favorite_exist_count, favorite_none_count|
  before_all do
    # ジャンルあり
    @all_articles = FactoryBot.create_list(:article, genre_exist_count, user: user)
    @genre = FactoryBot.create(:genre)
    @all_articles.each do |article|
      FactoryBot.create(:article_genre_relation, article: article, genre: @genre)
    end

    # ジャンルなし
    @all_articles += FactoryBot.create_list(:article, genre_none_count, user: user) if genre_none_count.positive?

    # お気に入りしているユーザーあり
    @all_favorite_articles = @all_articles
    if favorite_exist_count.positive?
      articles = FactoryBot.create_list(:article, favorite_exist_count, user: user)
      @user = FactoryBot.create(:user)
      articles.each do |article|
        FactoryBot.create(:article_favorite, article: article, user: @user)
      end
      @all_favorite_articles += articles
    end

    # お気に入りしているユーザーなし
    @all_favorite_articles += FactoryBot.create_list(:article, favorite_none_count, user: user) if favorite_none_count.positive?
  end
end
