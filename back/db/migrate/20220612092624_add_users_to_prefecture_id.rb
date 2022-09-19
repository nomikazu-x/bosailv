class AddUsersToPrefectureId < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :prefecture_id, :integer, comment: '出身都道府県ID'
    add_column :users, :city_id,       :bigint,  comment: '出身市区町村ID'
  end

  def down
    remove_column :users, :prefecture_id
    remove_column :users, :city_id
  end
end
