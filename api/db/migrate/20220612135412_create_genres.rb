class CreateGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :genres do |t|
      t.string :name, null: false, limit: 10, comment: 'ジャンル名'
      t.text :image, null: false,             comment: '画像'
      t.timestamps
    end
  end
end
