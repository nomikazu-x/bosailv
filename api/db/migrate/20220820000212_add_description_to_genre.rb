class AddDescriptionToGenre < ActiveRecord::Migration[6.1]
  def change
    add_column :genres, :description, :text, null: false, comment: '説明文'
  end
end
