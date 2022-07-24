# == Schema Information
#
# Table name: stocks
#
#  id                                   :bigint           not null, primary key
#  age(年代)                            :integer          default(0), not null
#  alcohol_spray(アルコールスプレー)    :integer          default(0)
#  aluminum_foil(アルミホイル)          :integer          default(0)
#  baby_bottle(哺乳瓶)                  :integer          default(0)
#  baby_wipe(お尻ふき)                  :integer          default(0)
#  battery_charger(充電器)              :integer          default(0)
#  body_warmer(カイロ)                  :integer          default(0)
#  canned_fruits(果物の缶詰)            :integer          default(0)
#  confectionery(お菓子)                :integer          default(0)
#  contact_lenses(コンタクトレンズ)     :integer          default(0)
#  denture_cleaner(入れ歯洗浄剤)        :integer          default(0)
#  diaper(おむつ)                       :integer          default(0)
#  dry_cell_battery(乾電池)             :integer          default(0)
#  flashlight(懐中電灯)                 :integer          default(0)
#  gloves(軍手)                         :integer          default(0)
#  lighter(マッチ)                      :integer          default(0)
#  mask(マスク)                         :integer          default(0)
#  medicine(常備薬)                     :integer          default(0)
#  milk_powder(粉ミルク)                :integer          default(0)
#  newspaper(新聞紙)                    :integer          default(0)
#  nutritional_supplement(栄養補助食品) :integer          default(0)
#  plastic_bag(ポリ袋)                  :integer          default(0)
#  prescription_drug(処方箋薬)          :integer          default(0)
#  radio(ラジオ)                        :integer          default(0)
#  retort_food(レトルト食品)            :integer          default(0)
#  retort_rice(レトルトご飯)            :integer          default(0)
#  ruck_sack(リュックサック)            :integer          default(0)
#  sanitary_item(生理用品)              :integer          default(0)
#  sex(性別)                            :integer          default(0), not null
#  simple_toilet(簡易トイレ)            :integer          default(0)
#  tissue_paper(ティッシュペーパー)     :integer          default(0)
#  toilet_paper(トイレットペーパー)     :integer          default(0)
#  water(水)                            :integer          default(0)
#  water_supply_bag(給水袋)             :integer          default(0)
#  wet_wipes(ウェットティッシュ)        :integer          default(0)
#  wrap(ラップ)                         :integer          default(0)
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#
require 'rails_helper'

RSpec.describe Stock, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
