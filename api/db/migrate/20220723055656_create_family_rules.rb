class CreateFamilyRules < ActiveRecord::Migration[6.1]
  def change
    create_table :family_rules do |t|
      t.references :user,                   null: false, foreign_key: true, comment: 'ユーザーID'
      t.text       :contact_means_memo,     null: false,                    comment: '緊急時連絡手段メモ'
      t.text       :refuge_memo,            null: false,                    comment: '避難方法メモ'
      t.text       :family_role_memo,       null: false,                    comment: '家族の役割分担メモ'
      t.text       :emergency_measure_memo, null: false,                    comment: '応急処置メモ'
      t.text       :leave_home_memo,        null: false,                    comment: '家を離れるときメモ'
      t.timestamps
    end
  end
end
