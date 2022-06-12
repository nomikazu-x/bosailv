class CreateArticleGenreRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :article_genre_relations do |t|
      t.references :article, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
