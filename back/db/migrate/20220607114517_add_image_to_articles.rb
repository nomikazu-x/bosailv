class AddImageToArticles < ActiveRecord::Migration[6.1]
  def up
    add_column :articles, :thumbnail, :text, comment: 'サムネイル画像'
  end

  def down
    remove_column :articles, :thumbnail
  end
end
