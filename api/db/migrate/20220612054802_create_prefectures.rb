class CreatePrefectures < ActiveRecord::Migration[6.1]
  def change
    create_table :prefectures do |t|
      t.string :name, null: false, comment: '都道府県名'
      t.timestamps
    end

    add_index :prefectures, :name, unique: true
  end
end
