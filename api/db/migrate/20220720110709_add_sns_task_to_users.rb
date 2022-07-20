class AddSnsTaskToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :sns_task,   :integer, null: false, default: 0, comment: 'SNS関係防災タスク'
    add_column :users, :house_task, :integer, null: false, default: 0, comment: '家庭関係防災タスク'
  end
end
