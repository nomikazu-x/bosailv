class CreateInfomations < ActiveRecord::Migration[6.1]
  def change
    create_table :infomations do |t|
      t.references :user, type: :bigint, foreign_key: true
      t.integer :label, null: false, default: 0
      t.string :title, null: false
      t.string :summary
      t.text :body
      t.integer :target, null: false
      t.datetime :started_at, null: false
      t.datetime :ended_at
      t.timestamps
    end
  end
end
