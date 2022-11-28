shared_context '記事一覧作成' do |default_articles_count, genre_exist_count, favorite_exist_count|
  before_all do
    @all_articles = FactoryBot.create_list(:article, default_articles_count, user: user)

    # ジャンルあり
    @genre = FactoryBot.create(:genre)
    @all_genre_articles = @all_articles
    if genre_exist_count.positive?
      @all_genre_articles.each do |article|
        FactoryBot.create(:article_genre_relation, article: article, genre: @genre)
      end
    end

    # お気に入りしているユーザーあり
    @other_user = FactoryBot.create(:user)
    @all_favorite_articles = @all_articles
    if favorite_exist_count.positive?
      @all_favorite_articles.each do |article|
        FactoryBot.create(:article_favorite, article: article, user: @other_user)
      end
    end
  end
end
