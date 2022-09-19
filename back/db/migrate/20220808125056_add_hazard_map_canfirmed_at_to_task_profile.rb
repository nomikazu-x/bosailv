class AddHazardMapCanfirmedAtToTaskProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :task_profiles, :hazard_map_confirmed_at, :datetime, comment: 'ハザードマップ確認日時'
  end
end
