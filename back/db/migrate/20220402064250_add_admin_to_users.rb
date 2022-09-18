class AddAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :power, :integer, default: 0,  null: false, comment: '権限'
  end
end
