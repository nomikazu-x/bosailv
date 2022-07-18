class CreateTaskCompletes < ActiveRecord::Migration[6.1]
  def change
    create_table :task_completes do |t|
      t.references :user, null: false, foreign_key: true, comment: 'ユーザーID'
      t.references :task, null: false, foreign_key: true, comment: '防災タスクID'
      t.timestamps

      t.index %i[user_id task_id], unique: true
    end
  end
end
