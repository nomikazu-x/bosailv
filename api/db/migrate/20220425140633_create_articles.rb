class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false, limit: 30
      t.text :content, null: false
      t.integer :category, default: 0, null: false
      t.timestamps
    end
  end
end
