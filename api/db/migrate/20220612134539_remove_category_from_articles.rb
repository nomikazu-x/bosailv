class RemoveCategoryFromArticles < ActiveRecord::Migration[6.1]
  def up
    remove_column :articles, :category
  end

  def down
    add_column :articles, :category, :integer
  end
end
