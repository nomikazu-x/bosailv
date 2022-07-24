# == Schema Information
#
# Table name: stocks
#
#  id                                   :bigint           not null, primary key
#  alcohol_spray(アルコールスプレー)    :integer
#  aluminum_foil(アルミホイル)          :integer
#  baby_bottle(哺乳瓶)                  :integer
#  baby_wipe(お尻ふき)                  :integer
#  battery_charger(充電器)              :integer
#  body_warmer(カイロ)                  :integer
#  canned_fruits(果物の缶詰)            :integer
#  confectionery(お菓子)                :integer
#  contact_lenses(コンタクトレンズ)     :integer
#  denture_cleaner(入れ歯洗浄剤)        :integer
#  diaper(おむつ)                       :integer
#  dry_cell_battery(乾電池)             :integer
#  flashlight(懐中電灯)                 :integer
#  gloves(軍手)                         :integer
#  lighter(マッチ)                      :integer
#  mask(マスク)                         :integer
#  medicine(常備薬)                     :integer
#  milk_powder(粉ミルク)                :integer
#  newspaper(新聞紙)                    :integer
#  nutritional_supplement(栄養補助食品) :integer
#  plastic_bag(ポリ袋)                  :integer
#  prescription_drug(処方箋薬)          :integer
#  radio(ラジオ)                        :integer
#  retort_food(レトルト食品)            :integer
#  retort_rice(レトルトご飯)            :integer
#  ruck_sack(リュックサック)            :integer
#  sanitary_item(生理用品)              :integer
#  simple_toilet(簡易トイレ)            :integer
#  tissue_paper(ティッシュペーパー)     :integer
#  toilet_paper(トイレットペーパー)     :integer
#  water(水)                            :integer
#  water_supply_bag(給水袋)             :integer
#  wet_wipes(ウェットティッシュ)        :integer
#  wrap(ラップ)                         :integer
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  family_id(家族ID)                    :bigint           not null
#
# Indexes
#
#  index_stocks_on_family_id  (family_id)
#
# Foreign Keys
#
#  fk_rails_...  (family_id => families.id)
#
FactoryBot.define do
  factory :stock do
    
  end
end
