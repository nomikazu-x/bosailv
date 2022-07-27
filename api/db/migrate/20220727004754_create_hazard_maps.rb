class CreateHazardMaps < ActiveRecord::Migration[6.1]
  def change
    create_table :hazard_maps do |t|
      t.bigint     :city_code,   null: false,  comment: '市町村コード'
      t.text       :tsunami,                   comment: '津波ハザードマップURL'
      t.text       :flood,                     comment: '洪水ハザードマップURL'
      t.text       :landslide,                 comment: '土砂災害ハザードマップURL'
      t.text       :inland_flood,              comment: '内水氾濫ハザードマップURL'
      t.text       :storm_surge,               comment: '高潮ハザードマップURL'
      t.text       :volcano,                   comment: '火山ハザードマップURL'
      t.text       :reservoir,                 comment: 'ため池ハザードマップURL'
      t.timestamps
    end

    add_foreign_key :hazard_maps, :cities, column: :city_code, primary_key: 'city_code' #外部キーを設定
  end
end
