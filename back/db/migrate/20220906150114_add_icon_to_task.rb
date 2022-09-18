class AddIconToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :icon, :string, null: false, comment: 'アイコン'
  end
end
