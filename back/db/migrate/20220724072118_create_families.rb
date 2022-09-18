class CreateFamilies < ActiveRecord::Migration[6.1]
  def change
    create_table :families do |t|
      t.references :user,         null: false, foreign_key: true, comment: 'ユーザーID'
      t.integer    :sex,          null: false, default: 0,        comment: '性別'
      t.integer    :age,          null: false, default: 0,        comment: '年代'
      t.timestamps
    end
  end
end
