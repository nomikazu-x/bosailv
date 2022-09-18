class CreatePointRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :point_records do |t|
      t.references :user, null: false, foreign_key: true, comment: "ユーザーID"
      t.integer :obtained_point, null: false,             comment: "獲得経験値"
      t.timestamps
    end
  end
end
