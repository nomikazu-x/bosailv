class CreateRequiredPoints < ActiveRecord::Migration[6.1]
  def change
    create_table :required_points do |t|
      t.integer :level, null: false
      t.integer :required_point, null: false
      t.integer :lifelong_point, null: false
      t.timestamps
    end
  end
end
