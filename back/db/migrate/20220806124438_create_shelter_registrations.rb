class CreateShelterRegistrations < ActiveRecord::Migration[6.1]
  def change
    create_table :shelter_registrations do |t|
      t.references :user, null: false, foreign_key: true,    comment: 'ユーザーID'
      t.references :shelter, null: false, foreign_key: true, comment: '避難所ID'
      t.timestamps

      t.index %i[user_id shelter_id], unique: true
    end
  end
end
