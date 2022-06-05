class AddProfileToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :username, :string, limit: 30, null: false
    add_column :users, :profile, :text
  end

  def down
    remove_column :users, :username
    remove_column :users, :profile
  end
end
