class AddProfileAndAddressAndUsernameToUsers < ActiveRecord::Migration[6.1]
  def up
    remove_column :users, :nickname

    add_column :users, :address, :string, limit: 30
    add_column :users, :profile, :string
    add_column :users, :username, :string, limit: 30

    add_index :users, :username, unique: true
  end

  def down
    add_column :users, :nickname, :string

    remove_column :users, :address, :string
    remove_column :users, :profile, :string
    remove_column :users, :username

    remove_index :users, :username, unique: true
  end
end
