class CreateCities < ActiveRecord::Migration[6.1]
  def change
    create_table :cities, id: false do |t| # 主キーをIDにする設定を解除する
      t.bigint     :city_code,  null: false, primary_key: true, comment: '市町村コード' # 主キーに設定
      t.string     :name,       null: false,                    comment: '市区町村名'
      t.references :prefecture, null: false, foreign_key: true, comment: '都道府県ID'
      t.timestamps
    end
  end
end
