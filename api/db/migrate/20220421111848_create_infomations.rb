class CreateInfomations < ActiveRecord::Migration[6.1]
  def change
    create_table :infomations do |t|

      t.timestamps
    end
  end
end
