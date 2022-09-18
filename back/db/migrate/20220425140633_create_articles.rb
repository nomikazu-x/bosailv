class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.references :user, null: false, foreign_key: true,  comment: 'ユーザーID'
      t.string :title, null: false, limit: 30,             comment: 'タイトル'
      t.text :content, null: false, limit: 4294967295,     comment: '内容'
      t.timestamps
    end
  end
end
