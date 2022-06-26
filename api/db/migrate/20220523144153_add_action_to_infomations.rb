class AddActionToInfomations < ActiveRecord::Migration[6.1]
  def change
    add_column :infomations, :action, :string,         comment: 'アクション'
    add_column :infomations, :action_user_id, :bigint, comment: 'アクションユーザーID'
    add_column :infomations, :article_id, :bigint,     comment: '記事ID'

    add_index :infomations, :article_id
  end
end
