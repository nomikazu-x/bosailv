class CreateArticleGenreRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :article_genre_relations do |t|
      t.references :article, null: false, foreign_key: true, comment: '記事ID'
      t.references :genre, null: false, foreign_key: true,   comment: 'ジャンルID'
      t.timestamps
    end
  end
end
