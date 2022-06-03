class AddLevelToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :level, :integer, default: 1, null: false
    add_column :users, :lifelong_point, :integer, default: 0, null: false
    add_column :users, :point_to_next, :integer, default: 5, null: false
  end
end
