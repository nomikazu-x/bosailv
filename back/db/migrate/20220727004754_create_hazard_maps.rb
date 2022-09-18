class CreateHazardMaps < ActiveRecord::Migration[6.1]
  def change
    create_table :hazard_maps do |t|
      t.references :city,        null: false, foreign_key: true, comment: '市町村ID'
      t.text       :tsunami,                                     comment: '津波ハザードマップURL'
      t.text       :flood,                                       comment: '洪水ハザードマップURL'
      t.text       :landslide,                                   comment: '土砂災害ハザードマップURL'
      t.text       :inland_flood,                                comment: '内水氾濫ハザードマップURL'
      t.text       :storm_surge,                                 comment: '高潮ハザードマップURL'
      t.text       :volcano,                                     comment: '火山ハザードマップURL'
      t.text       :reservoir,                                   comment: 'ため池ハザードマップURL'
      t.timestamps
    end
  end
end
