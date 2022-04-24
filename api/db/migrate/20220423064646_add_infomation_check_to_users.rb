class AddInfomationCheckToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :infomation_check_last_started_at, :datetime
  end
end
