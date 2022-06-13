class AddUsersToPrefectureId < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :prefecture_id, :integer
    add_column :users, :city_id, :integer
  end

  def down
    remove_column :users, :prefecture_id
    remove_column :users, :city_id
  end
end
