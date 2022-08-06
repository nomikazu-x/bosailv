class CreateShelters < ActiveRecord::Migration[6.1]
  def change
    create_table :shelters do |t|
      t.references :city,         null: false, foreign_key: true,            comment: '市町村ID'
      t.string     :city_name,    null: false,                               comment: '市町村名'
      t.string     :name,         null: false,                               comment: '施設・場所名'
      t.string     :address,      null: false,                               comment: '住所'
      t.boolean    :flood,        null: false, default: false,               comment: '洪水'
      t.boolean    :landslide,    null: false, default: false,               comment: '土砂'
      t.boolean    :storm_surge,  null: false, default: false,               comment: '高潮'
      t.boolean    :earthquake,   null: false, default: false,               comment: '地震'
      t.boolean    :tsunami,      null: false, default: false,               comment: '津波'
      t.boolean    :fire,         null: false, default: false,               comment: '火事'
      t.boolean    :inland_flood, null: false, default: false,               comment: '内水氾濫'
      t.boolean    :volcano,      null: false, default: false,               comment: '火山'
      t.boolean    :duplicate,    null: false, default: false,               comment: '指定避難所との重複'
      t.decimal    :latitude,     null: false, precision: 14, scale: 12,     comment: '緯度'
      t.decimal    :longitude,    null: false, precision: 15, scale: 12,     comment: '経度'
      t.string     :remark,                                                  comment: '備考'
      t.timestamps
    end
  end
end
