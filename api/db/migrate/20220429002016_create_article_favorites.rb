class CreateArticleFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :article_favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true
      t.timestamps

      t.index %i[user_id article_id], unique: true
    end
  end
end
