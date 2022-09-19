class CreateTaskProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :task_profiles do |t|
      t.references :user,     null: false, foreign_key: true, comment: 'ユーザーID'
      t.bigint :sns_tasks,    null: false, default: 0,        comment: 'SNS関係防災タスク'
      t.bigint :house_tasks,  null: false, default: 0,        comment: '家庭関係防災タスク'
      t.bigint :stock_tasks,  null: false, default: 0,        comment: '備蓄関係防災タスク'
      t.timestamps
    end
  end
end
