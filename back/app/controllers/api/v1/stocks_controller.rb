class Api::V1::StocksController < Api::V1::ApplicationController

  # GET /api/v1/stocks(.json) 備蓄品一覧API
  def index
    # ユーザーの家族情報から必要な備蓄品の数を求める
    stocks = []
    current_user.families.each do |family|
      # Stockテーブルから家族情報の性別・年代をもとにデータを取得し、配列に格納する
      stocks << Stock.find_by(age: family.age, sex: family.sex).attributes
    end
    # hashをmergeするときに、同一keyの場合はvalueを集計する
    @sum_stocks = stocks.inject { |old_stock, new_stock| old_stock.merge(new_stock) { |_, old_val, new_val| old_val + new_val } }
    # 使わない情報をインスタンス変数から除外する
    @sum_stocks.except!('id', 'sex', 'age', 'created_at', 'updated_at')

    # 防災タスクの達成状況を確認するためにタスクプロフィール情報を返す
    @task_profile = current_user.prepare_task_profile
  end

end
