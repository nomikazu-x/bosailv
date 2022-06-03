class AddActionToInfomations < ActiveRecord::Migration[6.1]
  def change
    add_column :infomations, :action, :string
    add_column :infomations, :action_user_id, :bigint
    add_column :infomations, :article_id, :bigint

    add_index :infomations, :article_id
  end
end
