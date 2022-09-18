class CreateRequiredPoints < ActiveRecord::Migration[6.1]
  def change
    create_table :required_points do |t|
      t.integer :level, null: false,          comment: "レベル"
      t.integer :point, null: false,          comment: "次のレベルまでに必要なポイント"
      t.integer :lifelong_point, null: false, comment: "合計獲得ポイント"
      t.timestamps
    end
  end
end
