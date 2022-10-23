class DropStocks < ActiveRecord::Migration[6.1]
  def change
    drop_table :stocks do |t|
      t.integer    :sex, null: false,       default: 0,     comment: '性別'
      t.integer    :age, null: false,       default: 0,     comment: '年代'
      t.integer    :water,                  default: 0,     comment: '水'
      t.integer    :retort_rice,            default: 0,     comment: 'レトルトご飯'
      t.integer    :retort_food,            default: 0,     comment: 'レトルト食品'
      t.integer    :nutritional_supplement, default: 0,     comment: '栄養補助食品'
      t.integer    :confectionery,          default: 0,     comment: 'お菓子'
      t.integer    :canned_fruits,          default: 0,     comment: '果物の缶詰'
      t.integer    :wet_wipes,              default: 0,     comment: 'ウェットティッシュ'
      t.integer    :alcohol_spray,          default: 0,     comment: 'アルコールスプレー'
      t.integer    :mask,                   default: 0,     comment: 'マスク'
      t.integer    :medicine,               default: 0,     comment: '常備薬'
      t.integer    :wrap,                   default: 0,     comment: 'ラップ'
      t.integer    :plastic_bag,            default: 0,     comment: 'ポリ袋'
      t.integer    :aluminum_foil,          default: 0,     comment: 'アルミホイル'
      t.integer    :toilet_paper,           default: 0,     comment: 'トイレットペーパー'
      t.integer    :tissue_paper,           default: 0,     comment: 'ティッシュペーパー'
      t.integer    :flashlight,             default: 0,     comment: '懐中電灯'
      t.integer    :dry_cell_battery,       default: 0,     comment: '乾電池'
      t.integer    :lighter,                default: 0,     comment: 'マッチ'
      t.integer    :body_warmer,            default: 0,     comment: 'カイロ'
      t.integer    :contact_lenses,         default: 0,     comment: 'コンタクトレンズ'
      t.integer    :battery_charger,        default: 0,     comment: '充電器'
      t.integer    :gloves,                 default: 0,     comment: '軍手'
      t.integer    :newspaper,              default: 0,     comment: '新聞紙'
      t.integer    :radio,                  default: 0,     comment: 'ラジオ'
      t.integer    :simple_toilet,          default: 0,     comment: '簡易トイレ'
      t.integer    :water_supply_bag,       default: 0,     comment: '給水袋'
      t.integer    :sanitary_item,          default: 0,     comment: '生理用品'
      t.integer    :milk_powder,            default: 0,     comment: '粉ミルク'
      t.integer    :diaper,                 default: 0,     comment: 'おむつ'
      t.integer    :baby_wipe,              default: 0,     comment: 'お尻ふき'
      t.integer    :baby_bottle,            default: 0,     comment: '哺乳瓶'
      t.integer    :denture_cleaner,        default: 0,     comment: '入れ歯洗浄剤'
      t.integer    :prescription_drug,      default: 0,     comment: '処方箋薬'
      t.integer    :ruck_sack,              default: 0,     comment: 'リュックサック'
      t.timestamps
    end
  end
end