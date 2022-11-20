class AddCodeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :code, :string, null: false, comment: 'コード'
  end
end
