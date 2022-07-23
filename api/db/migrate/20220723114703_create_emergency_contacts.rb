class CreateEmergencyContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :emergency_contacts do |t|
      t.references :user,         null: false, foreign_key: true, comment: 'ユーザーID'
      t.string     :name,         null: false,                    comment: '連絡先名'
      t.string     :phone_number, null: false,                    comment: '電話番号'
      t.timestamps
    end
  end
end
