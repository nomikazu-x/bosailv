class CreateArticleComments < ActiveRecord::Migration[6.1]
  def change
    create_table :article_comments do |t|
      t.references :user, null: false, foreign_key: true,    comment: 'ユーザーID'
      t.references :article, null: false, foreign_key: true, comment: '記事ID'
      t.text :content, null: false,                          comment: '内容'
      t.timestamps
    end
  end
end
