class AddIconToGenre < ActiveRecord::Migration[6.1]
  def change
    add_column :genres, :icon, :string, null: false, comment: 'アイコン'
  end
end
