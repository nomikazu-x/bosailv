class CreateInfomations < ActiveRecord::Migration[6.1]
  def change
    create_table :infomations do |t|
      t.integer :label, null: false, default: 0, comment: 'ラベル'
      t.string :title,                           comment: 'タイトル'
      t.string :summary,                         comment: '概要'
      t.text   :body,                            comment: '本文'

      t.datetime :started_at, null: false, comment: '開始日時'
      t.datetime :ended_at,                comment: '終了日時'
      t.datetime :force_started_at,        comment: '強制表示開始日時'
      t.datetime :force_ended_at,          comment: '強制表示終了日時'

      t.integer    :target, null: false,                    comment: '対象'
      t.references :user, type: :bigint, foreign_key: true, comment: 'ユーザーID'

      t.timestamps
    end
  end
end
