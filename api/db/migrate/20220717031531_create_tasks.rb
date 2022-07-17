class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.text   :image,   null: false,                    comment: '画像'
      t.string :title,   null: false, limit: 30,         comment: 'タイトル'
      t.string :summary, null: false, limit: 50,         comment: '概要'
      t.text   :body,    null: false, limit: 4294967295, comment: '本文'
      t.timestamps
    end
  end
end
