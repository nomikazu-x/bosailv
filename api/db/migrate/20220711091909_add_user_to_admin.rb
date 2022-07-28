class AddUserToAdmin < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :is_admin, :boolean, default: false,  null: false, comment: '管理者フラグ'
    add_column :users, :destroy_schedule_at, :datetime,                   comment: '削除予定日時'

    remove_column :users, :power, :integer
  end

  def down
    remove_column :users, :is_admin, :boolean, default: false,  null: false, comment: '管理者フラグ'
    remove_column :users, :destroy_schedule_at, :datetime,                   comment: '削除予定日時'

    add_column :users, :power, :integer, default: 0,  null: false,           comment: '権限'
  end
end
